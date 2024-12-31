{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.starship = lib.mkIf config.shell.starship.enable {
    enable = true;
    settings = pkgs.lib.importTOML ./starship.toml;
  };
}
