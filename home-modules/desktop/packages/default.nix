{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = lib.mkIf config.desktop.enable (with pkgs; [
    gimp
    nautilus
    obs-studio
    obsidian
    openrazer-daemon
    pavucontrol
    polychromatic
    themechanger
    typst
    vesktop
    wineWowPackages.waylandFull
    wl-clicker
    zoom
    zotero

    # games
    prismlauncher
  ]);
}
