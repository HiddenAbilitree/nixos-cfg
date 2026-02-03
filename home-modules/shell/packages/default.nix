{
  config,
  pkgs,
  lib,
  twopass,
  alejandra,
  slop,
  ...
}:
lib.mkIf config.shell.packages.enable {
  home.packages = with pkgs; [
    awscli2
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
    lean4
    libqalculate
    # mongosh
    gdu
    nmap
    reptyr
    oxlint
    ruff
    rustfmt
    terraform
    tldr # man pages
    tokei
    vhs
    wireguard-tools
    xh
    dua
    w3m
    twopass.packages.${pkgs.stdenv.hostPlatform.system}.default
    alejandra.defaultPackage.${pkgs.stdenv.hostPlatform.system}
    slop.packages.${pkgs.stdenv.hostPlatform.system}.default
    claude-code
    codex
    # gemini-cli
  ];
}
