{
  config,
  aagl,
  ...
}: {
  imports = [aagl.nixosModules.default];

  programs.anime-game-launcher.enable = config.desktop.games.moe.aagl.enable;
  programs.honkers-railway-launcher.enable = config.desktop.games.moe.honkers.enable;
}
