{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = lib.mkIf config.desktop.enable (with pkgs; [
    gimp
    easyeffects
    ghidra
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
    zoom
    zotero

    # games
    prismlauncher
  ]);
}
