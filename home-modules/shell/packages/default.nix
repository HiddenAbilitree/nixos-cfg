{
  config,
  pkgs,
  lib,
  twopass,
  alejandra,
  ...
}:
lib.mkIf config.shell.packages.enable {
  home.packages = with pkgs; [
    # awscli2
    amdgpu_top
    rclone
    bluetuith
    charm-freeze
    devenv
    dig
    ffmpeg
    glow # markdown renderer
    gum
    hwinfo
    hyperfine
    libqalculate
    mongosh
    gdu
    nmap
    reptyr
    oxlint
    ruff
    rustfmt
    tldr # man pages
    tokei
    vhs
    wireguard-tools
    xh
    dua
    w3m
    twopass.packages.${pkgs.stdenv.hostPlatform.system}.default
    alejandra.defaultPackage.${pkgs.stdenv.hostPlatform.system}

    claude-code
    codex
    # gemini-cli
  ];
}
