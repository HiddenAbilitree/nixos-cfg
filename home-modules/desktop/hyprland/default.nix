{
  config,
  osConfig,
  hyprland,
  lib,
  ocr,
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
      ocr.packages.${pkgs.stdenv.hostPlatform.system}.default
      pkgs.coreutils
      pkgs.grimblast
      pkgs.libnotify
      pkgs.pandoc
      pkgs.wl-clipboard
    ];
    text = ''
      work_dir="$(mktemp -d)"
      trap 'rm -rf "$work_dir"' EXIT

      if ! grimblast --freeze save area "$work_dir/image.png" >/dev/null; then
        exit 0
      fi

      if ! ocr "$work_dir/image.png" "$@" --output "$work_dir/text"; then
        notify-send --app-name="Hyprland OCR" "OCR failed" "Could not transcribe the screenshot."
        exit 1
      fi

      wl-copy --type 'text/plain;charset=utf-8' < "$work_dir/text"
      notify-send --app-name="Hyprland OCR" "OCR complete" "Text copied to the clipboard."
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
