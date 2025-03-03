{
  config,
  lib,
  ...
}: let
  aagl-gtk-on-nix = import (builtins.fetchTarball {
    url = "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz";
    sha256 = "0f59radafvzdfn3ar1y6glx9ixc9hbvysaalsp492ixp8ihpkbxv";
  });
in
  lib.mkIf config.desktop.games.honkers.enable {
    home.packages = [aagl-gtk-on-nix.the-honkers-railway-launcher];
  }
