{
  config,
  pkgs,
  lib,
  ...
}:
lib.mkIf config.shell.packages.enable {
  home.packages = with pkgs; [
    bat # fancy cat
    bluetuith
    dig
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
    xh
    dua
    w3m
  ];
}
