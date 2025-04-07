{
  config,
  lib,
  ...
}:
lib.mkIf config.desktop.games.honkers.enable {
  home.packages = let
    aagl-gtk-on-nix = import (builtins.fetchTarball {
      url = "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz";
      sha256 = "1z8z53p7qd4mfawi098dls7mx52ax2cvygn3bd20n1va1l4zsx0z";
    });
  in [aagl-gtk-on-nix.the-honkers-railway-launcher];
}
