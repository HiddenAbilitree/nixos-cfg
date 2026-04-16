{
  config,
  osConfig,
  hyprland,
  lib,
  pkgs,
  split-monitor-workspaces,
  ...
}: {
  imports = [
    ./hyprlock
    ./hypridle
    ./hyprpaper
  ];

  options.desktop.hyprland.enable = lib.mkEnableOption "Hyprland";

  config = lib.mkIf config.desktop.hyprland.enable {
    home.packages = with pkgs; [
      hyprshot
      hyprpicker
      hyprpolkitagent
      xdg-desktop-portal-gtk
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      extraConfig =
        builtins.readFile ./hyprland.conf
        + lib.optionalString (!osConfig.laptop.enable) ''
          bindl = $mod, M, exec, hyprctl dispatch dpms toggle
        '';
      plugins = [
        split-monitor-workspaces.packages.${pkgs.stdenv.hostPlatform.system}.split-monitor-workspaces
      ];
    };
  };
}
