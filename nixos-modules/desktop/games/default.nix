{
  lib,
  config,
  ...
}: {
  imports = [
    ./moe.nix
  ];
  options.desktop.games = {
    enable = lib.mkEnableOption "Games";
    pokepath-td.enable = lib.mkEnableOption "PokePathTD";
    moe = {
      enable = lib.mkEnableOption "Moe Games";
      aagl.enable = lib.mkEnableOption "AAGL";
      honkers.enable = lib.mkEnableOption "Honkers";
    };
  };

  config.desktop.games = lib.mkIf config.desktop.games.enable {
    pokepath-td.enable = lib.mkDefault true;
    moe = {
      enable = lib.mkDefault true;
      honkers.enable = lib.mkDefault config.desktop.games.moe.enable;
      aagl.enable = lib.mkDefault config.desktop.games.moe.enable;
    };
  };
}
