{
  config,
  lib,
  hyprland,
  pkgs,
  ...
}: {
  programs.hyprland = lib.mkIf config.desktop.hyprland.enable {
    enable = true;
    package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
}
