{
  config,
  lib,
  pkgs,
  ...
}:
let
  equibop-discord = pkgs.symlinkJoin {
    name = "equibop-discord";
    paths = [ pkgs.equibop ];
    postBuild = ''
      rm $out/share/applications/equibop.desktop
      sed \
        -e 's|^Name=.*|Name=Discord|' \
        -e 's|^Icon=.*|Icon=${pkgs.papirus-icon-theme}/share/icons/Papirus/128x128/apps/discord.svg|' \
        ${pkgs.equibop}/share/applications/equibop.desktop > $out/share/applications/equibop.desktop
    '';
  };
in
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
      equibop-discord
      wineWow64Packages.waylandFull
      wl-clipboard
      # packages-nix.packages.${pkgs.stdenv.hostPlatform.system}.nteract
    ];

}
