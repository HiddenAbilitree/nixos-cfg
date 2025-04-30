{
  config,
  pkgs,
  ...
}: {
  programs.starship = {
    inherit (config.shell.starship) enable;
    settings = pkgs.lib.importTOML ./starship.toml;
  };
}
