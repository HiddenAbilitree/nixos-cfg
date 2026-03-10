{
  config,
  lib,
  pkgs,
  ...
}: {
  options.shell.starship.enable = lib.mkEnableOption "Starship";

  config = lib.mkIf config.shell.starship.enable {
    programs.starship = {
      enable = true;
      settings = pkgs.lib.importTOML ./starship.toml;
    };
  };
}
