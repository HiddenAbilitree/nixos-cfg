{
  lib,
  config,
  ...
}: {
  imports = [./moe.nix];
  options.desktop.games = {
    enable = lib.mkEnableOption "Games";
    moe = {
      enable = lib.mkEnableOption "Moe Games";
      aagl.enable = lib.mkEnableOption "AAGL";
      honkers.enable = lib.mkEnableOption "Honkers";
    };
  };

  config.desktop.games = lib.mkIf config.desktop.games.enable {
    moe = {
      enable = lib.mkDefault true;
      honkers.enable = lib.mkDefault config.desktop.games.moe.enable;
      aagl.enable = lib.mkDefault config.desktop.games.moe.enable;
    };
  };
}
