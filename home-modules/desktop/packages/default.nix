{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = lib.mkIf config.desktop.enable (with pkgs; [
    gimp
    google-chrome
    libreoffice-qt6-fresh
    nautilus
    obs-studio
    obsidian
    openrazer-daemon
    hyprsunset
    pavucontrol
    polychromatic
    postman
    moonlight-qt
    mpv
    vlc
    swww
    themechanger
    typst
    vesktop
    wineWowPackages.waylandFull
    wireguard-tools
    wireshark-qt
    wl-clicker
    kdePackages.xwaylandvideobridge
    gnome-themes-extra
    ventoy-full
    zoom
    zotero
  ]);
}
