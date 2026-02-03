{
  config,
  lib,
  pkgs,
  helium,
  ...
}:
lib.mkIf config.desktop.enable {
  home.packages = with pkgs; [
    affine
    brave
    copyq
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
    # kdePackages.kdenlive
    libreoffice
    # librewolf
    libsecret
    moonlight-qt
    nautilus
    helium.legacyPackages.${pkgs.stdenv.hostPlatform.system}.helium-nightly
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
    vlc
    wineWowPackages.waylandFull
    wireshark
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
