{
  config,
  hyprland,
  lib,
  pkgs,
  ...
}:
{
  options.desktop.hyprland.enable = lib.mkEnableOption "Hyprland";

  config = lib.mkIf config.desktop.hyprland.enable {
    programs.hyprland = {
      enable = true;
      package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    xdg.portal.config.hyprland.default = [
      "hyprland"
      "gtk"
    ];

    security.pam.services.hyprlock = lib.mkIf config.home-manager.users.ezhang.desktop.hyprland.hyprlock.enable {
      fprintAuth = false;
    };
  };
}
