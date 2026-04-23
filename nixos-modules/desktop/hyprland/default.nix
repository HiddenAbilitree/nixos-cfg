{
  config,
  hyprland,
  lib,
  pkgs,
  ...
}: {
  options.desktop.hyprland.enable = lib.mkEnableOption "Hyprland";

  config = lib.mkIf config.desktop.hyprland.enable {
    programs.hyprland = {
      enable = true;
      package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    xdg.portal = {
      extraPortals = [pkgs.xdg-desktop-portal-wlr];
      config.common = {
        "org.freedesktop.impl.portal.ScreenCast" = "wlr";
        "org.freedesktop.impl.portal.Screenshot" = "wlr";
      };
      config.hyprland = {
        default = ["hyprland" "gtk"];
        "org.freedesktop.impl.portal.ScreenCast" = "wlr";
        "org.freedesktop.impl.portal.Screenshot" = "wlr";
      };
    };
  };
}
