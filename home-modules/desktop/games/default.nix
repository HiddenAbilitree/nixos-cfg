{
  config,
  lib,
  ...
}: {
  imports = [./lutris.nix ./osu.nix ./roblox.nix];
  desktop.games = lib.mkIf config.desktop.games.enable {
    osu.enable = lib.mkDefault true;
    lutris.enable = lib.mkDefault true;
    roblox.enable = lib.mkDefault true;
  };
}
