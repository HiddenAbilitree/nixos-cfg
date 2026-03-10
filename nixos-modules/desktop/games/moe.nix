{
  aagl,
  config,
  lib,
  ...
}: {
  imports = [aagl.nixosModules.default];

  programs.anime-game-launcher.enable = config.desktop.games.moe.aagl.enable;
  programs.honkers-railway-launcher.enable = config.desktop.games.moe.honkers.enable;

  networking.extraHosts = lib.mkIf config.desktop.games.moe.enable ''
    0.0.0.0 log-upload-os.hoyoverse.com
    0.0.0.0 sg-public-data-api.hoyoverse.com
    0.0.0.0 log-upload.mihoyo.com
    0.0.0.0 public-data-api.mihoyo.com
  '';
}
