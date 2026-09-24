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
