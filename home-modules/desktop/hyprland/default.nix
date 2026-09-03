{
  config,
  osConfig,
  hyprland,
  lib,
  pkgs,
  split-monitor-workspaces,
  ...
}:
let
  hyprlandPackage = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  hyprlandPortalPackage =
    hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  monitorPriority =
    if config.desktop.monitors == null then
      "{}"
    else if config.desktop.monitors.primary == "left" then
      ''{ "${config.desktop.monitors.left}", "${config.desktop.monitors.right}" }''
    else
      ''{ "${config.desktop.monitors.right}", "${config.desktop.monitors.left}" }'';
  secondaryMonitor =
    if config.desktop.monitors == null then
      "nil"
    else if config.desktop.monitors.primary == "left" then
      ''"${config.desktop.monitors.right}"''
    else
      ''"${config.desktop.monitors.left}"'';
  ollamaApiUrl = "http://127.0.0.1:${toString osConfig.services.ollama.port}/api/chat";
  ollamaModel = "gemma4:latest";
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
      pkgs.curl
      pkgs.grimblast
      pkgs.jq
      pkgs.libnotify
      pkgs.wl-clipboard
    ];
    text = ''
      mode="text"
      case "''${1:-}" in
        "")
          ;;
        --latex)
          mode="latex"
          shift
          ;;
        *)
          notify-send --app-name="Hyprland OCR" "Invalid OCR mode" "Usage: hyprland-ocr [--latex]"
          exit 2
          ;;
      esac

      if [[ "$#" -ne 0 ]]; then
        notify-send --app-name="Hyprland OCR" "Invalid OCR arguments"
        exit 2
      fi

      screenshot_file="$(mktemp --suffix=.png)"
      trap 'rm -f "$screenshot_file"' EXIT

      if ! grimblast --freeze save area "$screenshot_file" >/dev/null; then
        exit 0
      fi

      if [[ "$mode" == "latex" ]]; then
        prompt='Transcribe every mathematical expression, symbol, and label visible in this image into LaTeX. Include all separate labels and expressions, in reading order, one per line when needed. Return only raw LaTeX source with no Markdown fences, explanation, or surrounding dollar-sign delimiters.'
      else
        prompt='Read all visible text in this image. Return only the transcribed text, preserving line breaks and punctuation. Do not describe the image, add corrections, or use Markdown.'
      fi

      if ! response="$(
        jq -n \
          --arg model "${ollamaModel}" \
          --arg prompt "$prompt" \
          --rawfile image <(base64 --wrap=0 "$screenshot_file") \
          '{
            model: $model,
            messages: [{ role: "user", content: $prompt, images: [$image] }],
            stream: false,
            think: false,
            keep_alive: -1,
            options: { temperature: 0 }
          }' |
          curl --fail --silent --show-error --max-time 300 \
            --header 'Content-Type: application/json' \
            --data-binary @- \
            "${ollamaApiUrl}"
      )"; then
        notify-send --app-name="Hyprland OCR" "OCR failed" "Could not reach Ollama."
        exit 1
      fi

      if ! ocr_text="$(
        printf '%s' "$response" |
          jq --exit-status --raw-output '.message.content // empty'
      )"; then
        notify-send --app-name="Hyprland OCR" "OCR failed" "Ollama returned no OCR text."
        exit 1
      fi

      if [[ -z "''${ocr_text//[[:space:]]/}" ]]; then
        notify-send --app-name="Hyprland OCR" "OCR found no text"
        exit 0
      fi

      printf '%s' "$ocr_text" | wl-copy --type 'text/plain;charset=utf-8'

      if [[ "$mode" == "latex" ]]; then
        notify-send --app-name="Hyprland OCR" "LaTeX OCR complete" "LaTeX copied to the clipboard."
      else
        notify-send --app-name="Hyprland OCR" "OCR complete" "Text copied to the clipboard."
      fi
    '';
  };
  hyprlandLatexOcr = pkgs.writeShellApplication {
    name = "hyprland-latex-ocr";
    runtimeInputs = [ hyprlandOcr ];
    text = ''
      exec hyprland-ocr --latex "$@"
    '';
  };
in
{
  imports = [
    ./hyprlock
    ./hypridle
    ./hyprpaper
  ];

  options.desktop.hyprland.enable = lib.mkEnableOption "Hyprland";

  config = lib.mkIf config.desktop.hyprland.enable {
    home.packages =
      with pkgs;
      [
        grimblast
        hyprpicker
        hyprpolkitagent
        xdg-desktop-portal-gtk
      ]
      ++ [
        hyprlandOcr
        hyprlandLatexOcr
        resetWindowWorkspaces
      ];

    wayland.windowManager.hyprland = {
      enable = true;
      package = hyprlandPackage;
      portalPackage = hyprlandPortalPackage;
      configType = "lua";
      extraConfig = ''
        package.path = package.path .. ";${patchedSplitMonitorWorkspaces}/lua/?.lua"
        local smw = require("split-monitor-workspaces")
        local monitor_priority = ${monitorPriority}
        local obsidian_monitor = ${secondaryMonitor}

      ''
      + builtins.readFile ./hyprland.lua
      + lib.optionalString (!osConfig.laptop.enable) ''
        hl.bind(mod .. " + M", hl.dsp.dpms({ action = "toggle" }), { locked = true })
      '';
    };
  };
}
