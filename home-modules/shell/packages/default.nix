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
    kubectl
    libqalculate
    minikube
    mongosh
    gdu
    nmap
    reptyr
    eslint_d
    oxlint
    rustfmt
    tldr # man pages
    xh
    dua
    w3m
  ];
}
