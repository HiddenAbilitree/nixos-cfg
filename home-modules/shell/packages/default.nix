{
  config,
  pkgs,
  lib,
  ...
}:
lib.mkIf config.shell.packages.enable {
  home.packages = with pkgs; [
    # awscli2
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
    rustfmt
    tldr # man pages
    tokei
    vhs
    xh
    dua
    w3m
  ];
}
