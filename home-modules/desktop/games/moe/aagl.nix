{
  config,
  lib,
  ...
}:
lib.mkIf config.desktop.games.moe.aagl.enable {
  services.flatpak.packages = [
    {
      appId = "moe.launcher.an-anime-game-launcher";
      origin = "launcher.moe";
    }
  ];
  desktop.games.moe.enable = lib.mkForce true;
  misc.flatpak.enable = lib.mkDefault true;
}
