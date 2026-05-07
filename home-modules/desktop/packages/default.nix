{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.desktop.enable {
  home.packages = with pkgs; [
    affine
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
    jetbrains.idea
    # kdePackages.kdenlive
    # libreoffice
    # librewolf
    libsecret
    moonlight-qt
    nautilus
    obsidian
    obs-cmd
    openrazer-daemon
    pavucontrol
    piper
    polychromatic
    postman
    protonup-qt
    # rquickshare
    sqlite-web
    themechanger
    tor-browser
    typst
    vesktop
    vinegar
    vlc
    wineWow64Packages.waylandFull
    # wl-clicker
    wl-clipboard
    ydotool
    zoom-us
    zotero
    # androidStudioPackages.canary
    # android-studio-full
    android-studio
  ];
}
