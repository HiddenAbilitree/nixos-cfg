{
  pkgs,
  split-monitor-workspaces,
  lib,
  config,
  hyprland,
  ...
}: {
  imports = [
    ./hyprlock
    ./hypridle
    ./hyprpaper
  ];

  config = lib.mkIf config.desktop.hyprland.enable {
    home.packages = with pkgs; [
      hyprshot
      hyprpicker
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      extraConfig = builtins.readFile ./hyprland.conf;
      plugins = [
        split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
      ];
    };
  };
}
