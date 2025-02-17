{
  config,
  lib,
  ...
}: let
  aagl-gtk-on-nix = import (builtins.fetchTarball {
    url = "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz";
    sha256 = "0v59frhfnyy7pbmbv7bdzssdp554bjsgmmm4dw31p5askysmlvib";
  });
in
  lib.mkIf config.desktop.games.honkers.enable {
    home.packages = [aagl-gtk-on-nix.the-honkers-railway-launcher];
  }
