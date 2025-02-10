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
    wireguard-tools
    wireshark-qt
    wl-clicker
    xwaylandvideobridge
    gnome-themes-extra
    ventoy-full
    zoom
    zotero
  ]);
}
