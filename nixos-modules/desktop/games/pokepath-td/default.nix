{
  pkgs,
  config,
  lib,
  ...
}: let
  pname = "pokepath-td";
  version = "1.0.0";

  pokepath-td = pkgs.appimageTools.wrapType2 {
    inherit pname version;
    src = ./PokePathTD.AppImage;
  };
in {
  config = lib.mkIf config.desktop.games.pokepath-td.enable {
    environment.systemPackages = [pokepath-td];
  };
}
