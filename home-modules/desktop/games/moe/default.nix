{
  config,
  lib,
  ...
}: {
  imports = [
    ./aagl.nix
    ./honkers.nix
  ];

  options.desktop.games.moe = {
    enable = lib.mkEnableOption "moe flatpak repo";
    aagl.enable = lib.mkEnableOption "aagl";
    honkers.enable = lib.mkEnableOption "honkers";
  };

  config.services.flatpak.remotes = lib.mkIf config.desktop.games.moe.enable [
    {
      name = "flathub";
      location = "https://flathub.org/repo/flathub.flatpakrepo";
    }
    {
      name = "launcher.moe";
      location = "https://gol.launcher.moe/gol.launcher.moe.flatpakrepo";
    }
  ];
}
