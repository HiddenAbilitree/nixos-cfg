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
    nmap
    reptyr
    rustfmt
    tldr # man pages
    w3m
  ];
}
