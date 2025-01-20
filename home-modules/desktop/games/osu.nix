{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs;
    lib.mkIf config.desktop.games.osu.enable [
      osu-lazer-bin
    ];
}
