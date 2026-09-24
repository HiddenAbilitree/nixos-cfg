{
  config,
  lib,
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
      blender
      easyeffects
      firefox
      font-manager
      google-chrome
      hyprsunset
      libsecret
      losslesscut
      moonlight-qt
      nautilus
      obsidian
      ruff
      obs-cmd
      pavucontrol
      piper
      protonup-qt
      themechanger
      tor-browser
      equibop
      wineWow64Packages.waylandFull
      wl-clipboard
      # packages-nix.packages.${pkgs.stdenv.hostPlatform.system}.nteract
    ];

}
