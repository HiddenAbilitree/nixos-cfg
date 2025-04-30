{
  pkgs,
  lib,
  config,
  prismlauncher,
  ...
}: {
  imports = [./lutris.nix ./roblox.nix ./honkers.nix];
  home.packages = with pkgs;
    [
      mangohud
      (lib.mkIf config.desktop.games.osu.enable osu-lazer-bin)
      (lib.mkIf config.desktop.games.emulators.enable
        (retroarch.withCores (cores: with cores; [mgba dolphin citra])))
    ]
    ++ lib.optionals config.desktop.games.minecraft.enable [lunar-client prismlauncher.packages.${pkgs.system}.prismlauncher];

  home.file = {
    ".local/share/PrismLauncher/themes/Tokyo-Night-Storm" = {
      inherit (config.desktop.games.minecraft) enable;
      source = ./prism-launcher;
    };
  };

  desktop.games = lib.mkIf config.desktop.games.enable {
    osu.enable = lib.mkDefault true;
    minecraft.enable = lib.mkDefault true;
    lutris.enable = lib.mkDefault true;
    roblox.enable = lib.mkDefault true;
    honkers.enable = lib.mkDefault true;
    emulators.enable = lib.mkDefault true;
  };
}
