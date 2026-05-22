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
  splitMonitorWorkspacesPackage = split-monitor-workspaces.packages.${pkgs.stdenv.hostPlatform.system}.split-monitor-workspaces;

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
      ++ [resetWindowWorkspaces];

    wayland.windowManager.hyprland = {
      enable = true;
      package = hyprlandPackage;
      portalPackage = hyprlandPortalPackage;
      configType = "lua";
      extraConfig =
        ''
          hl.plugin.load("${splitMonitorWorkspacesPackage}/lib/libsplit-monitor-workspaces.so")

        ''
        + builtins.readFile ./hyprland.lua
        + lib.optionalString (!osConfig.laptop.enable) ''
          hl.bind(mod .. " + M", hl.dsp.dpms({ action = "toggle" }), { locked = true })
        '';
    };
  };
}
