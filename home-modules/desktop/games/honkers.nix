{
  config,
  lib,
  ...
}:
lib.mkIf config.desktop.games.honkers.enable {
  home.packages = let
    aagl-gtk-on-nix = import (builtins.fetchTarball {
      url = "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz";
      sha256 = "0z9lg60k9f58asx6myz25ysp3finfa8yrzz6ars2lasi5zhvg4s9";
    });
  in [aagl-gtk-on-nix.the-honkers-railway-launcher];
}
