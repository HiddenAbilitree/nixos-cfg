{
  config,
  osConfig,
  hyprland,
  lib,
  pkgs,
  split-monitor-workspaces,
  ...
}: let
  hyprlandPackage = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  hyprlandPortalPackage = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  tesseractEnglish = pkgs.tesseract5.override {enableLanguages = ["eng"];};
  patchedSplitMonitorWorkspaces = pkgs.applyPatches {
    name = "split-monitor-workspaces-patched";
    src = split-monitor-workspaces;
    patches = [
      ./patches/split-monitor-workspaces-rogue-workspace-exclusions.patch
    ];
  };

  resetWindowWorkspaces = pkgs.writeShellApplication {
    name = "hyprland-reset-window-workspaces";
    runtimeInputs = [
      hyprlandPackage
      pkgs.python3
    ];
    text = ''
      exec ${pkgs.python3}/bin/python3 ${./reset-window-workspaces.py} "$@"
    '';
  };

  hyprlandOcr = pkgs.writeShellApplication {
    name = "hyprland-ocr";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.hyprshot
      pkgs.imagemagick
      pkgs.libnotify
      tesseractEnglish
      pkgs.wl-clipboard
    ];
    text = ''
      normalize_hostname_line() {
        local line="$1"
        local candidate="$line"
        local annotation=""
        local annotation_regex='^(.*)[[:space:]]+(\([^)]*\)).*$'
        local before_cleanup
        local corrected=false

        if [[ "$line" =~ $annotation_regex ]]; then
          candidate="''${BASH_REMATCH[1]}"
          annotation=" ''${BASH_REMATCH[2]}"
        fi

        if [[ "$candidate" =~ [[:alnum:]][[:space:]]+[[:alnum:]] ]]; then
          printf '%s' "$line"
          return
        fi

        before_cleanup="$candidate"
        candidate="''${candidate//[[:space:]]/}"
        candidate="''${candidate//–/-}"
        candidate="''${candidate//—/-}"
        candidate="''${candidate//−/-}"

        if [[ "$candidate" =~ ^[^[:alnum:]]*([[:alnum:]].*[[:alnum:]])[^[:alnum:]]*$ ]]; then
          candidate="''${BASH_REMATCH[1]}"
        fi

        if [[ "$candidate" != "$before_cleanup" ]]; then
          corrected=true
        fi

        if [[ "$candidate" != *.*.amazonaws.com && "$candidate" != *.*.amazonaws.com.cn ]]; then
          printf '%s' "$line"
          return
        fi

        if [[ "$candidate" == *"|"* ]]; then
          candidate="''${candidate//|/1}"
          corrected=true
        fi

        while [[ "$candidate" =~ ^(vpce-[[:xdigit:]]*)/([[:xdigit:]/]+-.*)$ ]]; do
          candidate="''${BASH_REMATCH[1]}7''${BASH_REMATCH[2]}"
          corrected=true
        done

        if [[ "$candidate" =~ ^(.+\.[[:alpha:]]{2,4}-[[:alpha:]-]+-)[1Il](vpce\.amazonaws\.com(\.cn)?)$ ]]; then
          candidate="''${BASH_REMATCH[1]}1.''${BASH_REMATCH[2]}"
          corrected=true
        fi

        while [[ "$candidate" =~ ^(.*[.-][[:alpha:]]{2,4}-[[:alpha:]-]+-)[Il]([[:alpha:]]?)(\..*)$ ]]; do
          candidate="''${BASH_REMATCH[1]}1''${BASH_REMATCH[2]}''${BASH_REMATCH[3]}"
          corrected=true
        done

        if [[ "$corrected" == true && "$candidate" =~ ^([[:alnum:]]([[:alnum:]-]*[[:alnum:]])?\.)+[[:alpha:]]{2,63}$ ]]; then
          printf '%s%s' "$candidate" "$annotation"
        else
          printf '%s' "$line"
        fi
      }

      normalize_hostnames() {
        local first=true
        local line

        while IFS= read -r line; do
          if [[ "$first" == true ]]; then
            first=false
          else
            printf '\n'
          fi
          normalize_hostname_line "$line"
        done <<<"$1"
      }

      screenshot_file="$(mktemp --suffix=.png)"
      trap 'rm -f "$screenshot_file"' EXIT

      if ! hyprshot --mode region --freeze --raw --silent >"$screenshot_file"; then
        exit 0
      fi

      invert=()
      if [[ "$(
        magick "$screenshot_file" \
          -background white \
          -alpha remove \
          -colorspace Gray \
          -format '%[fx:mean<0.5]' \
          info:
      )" == "1" ]]; then
        invert=(-negate)
      fi

      if ! ocr_text="$(
        magick "$screenshot_file" \
          -background white \
          -alpha remove \
          -alpha off \
          -colorspace Gray \
          "''${invert[@]}" \
          -filter Lanczos \
          -resize 300% \
          -contrast-stretch 0.5%x0.5% \
          -unsharp 0x0.8+1+0 \
          -bordercolor white \
          -border 24x24 \
          png:- |
          tesseract stdin stdout -l eng --dpi 300 --psm 6 2>/dev/null
      )"; then
        notify-send --app-name="Hyprland OCR" "OCR failed"
        exit 1
      fi

      if [[ -z "''${ocr_text//[[:space:]]/}" ]]; then
        notify-send --app-name="Hyprland OCR" "OCR found no text"
        exit 0
      fi

      ocr_text="$(normalize_hostnames "$ocr_text")"

      printf '%s' "$ocr_text" | wl-copy --type 'text/plain;charset=utf-8'
      notify-send --app-name="Hyprland OCR" "OCR complete" "Text copied to the clipboard."
    '';
  };
in {
  imports = [
    ./hyprlock
    ./hypridle
    ./hyprpaper
  ];

  options.desktop.hyprland.enable = lib.mkEnableOption "Hyprland";

  config = lib.mkIf config.desktop.hyprland.enable {
    home.packages = with pkgs;
      [
        hyprshot
        hyprpicker
        hyprpolkitagent
        xdg-desktop-portal-gtk
      ]
      ++ [
        hyprlandOcr
        resetWindowWorkspaces
      ];

    wayland.windowManager.hyprland = {
      enable = true;
      package = hyprlandPackage;
      portalPackage = hyprlandPortalPackage;
      configType = "lua";
      extraConfig =
        ''
          package.path = package.path .. ";${patchedSplitMonitorWorkspaces}/lua/?.lua"
          local smw = require("split-monitor-workspaces")

        ''
        + builtins.readFile ./hyprland.lua
        + lib.optionalString (!osConfig.laptop.enable) ''
          hl.bind(mod .. " + M", hl.dsp.dpms({ action = "toggle" }), { locked = true })
        '';
    };
  };
}
