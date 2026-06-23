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
        normcap
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
          package.path = package.path .. ";${split-monitor-workspaces}/lua/?.lua"
          local smw = require("split-monitor-workspaces")

        ''
        + builtins.readFile ./hyprland.lua
        + lib.optionalString (!osConfig.laptop.enable) ''
          hl.bind(mod .. " + M", hl.dsp.dpms({ action = "toggle" }), { locked = true })
        '';
    };
  };
}
