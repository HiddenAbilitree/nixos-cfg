{
  config,
  hyprland,
  pkgs,
  ...
}: {
  programs.hyprland = {
    inherit (config.desktop.hyprland) enable;
    package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
}
