{
  config,
  lib,
  llm-agents,
  pkgs,
  ...
}:
lib.mkIf config.desktop.enable {
  home.packages =
    with pkgs;
    lib.optionals stdenv.hostPlatform.isDarwin [
      brave
      nerd-fonts._0xproto
      obsidian
      raycast
      zed-editor
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      easyeffects
      firefox
      font-manager
      google-chrome
      hyprsunset
      libsecret
      llm-agents.packages.${stdenv.hostPlatform.system}.paseo-desktop
      moonlight-qt
      nautilus
      obsidian
      obs-cmd
      pavucontrol
      piper
      protonup-qt
      themechanger
      tor-browser
      vesktop
      wineWow64Packages.waylandFull
      wl-clipboard
    ];
}
