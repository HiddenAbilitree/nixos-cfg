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
  };
}
