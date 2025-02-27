{
  pkgs,
  lib,
  config,
  prismlauncher,
  ...
}: {
  imports = [./lutris.nix ./roblox.nix ./honkers.nix];
  home.packages = with pkgs; [
    (lib.mkIf config.desktop.games.osu.enable osu-lazer-bin)
    (lib.mkIf config.desktop.games.minecraft.enable prismlauncher.packages.${pkgs.system}.prismlauncher)
  ];

  desktop.games = lib.mkIf config.desktop.games.enable {
    osu.enable = lib.mkDefault true;
    minecraft.enable = lib.mkDefault true;
    lutris.enable = lib.mkDefault true;
    roblox.enable = lib.mkDefault true;
    honkers.enable = lib.mkDefault true;
  };
}
