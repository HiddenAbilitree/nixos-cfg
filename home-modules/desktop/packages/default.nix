{
  config,
  # swww,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.desktop.enable
{
  home.packages = with pkgs; [
    brave
    blender-hip
    # davinci-resolve
    dbeaver-bin
    easyeffects
    element-desktop
    firefox
    font-manager
    gimp
    godot
    google-chrome
    gnome-disk-utility
    hyprsunset
    inkscape
    # jetbrains.idea-ultimate
    kdePackages.kdenlive
    # kdePackages.xwaylandvideobridge
    libreoffice
    librewolf
    libsecret
    moonlight-qt
    nautilus
    obsidian
    # obs-studio
    obs-cmd
    openrazer-daemon
    pavucontrol
    piper
    polychromatic
    postman
    protonup-qt
    rquickshare
    # swww.packages.${pkgs.system}.swww
    sqlite-web
    themechanger
    tor-browser
    typst
    vesktop
    vlc
    wineWowPackages.waylandFull
    wireshark-qt
    wl-clicker
    wl-clipboard
    ydotool
    zoom-us
    zotero
  ];
}
