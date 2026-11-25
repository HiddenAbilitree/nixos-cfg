{
  config,
  lib,
  packages-nix,
  system,
  ...
}:
{
  options.desktop.doop.enable = lib.mkEnableOption "doop design canvas";

  config = lib.mkIf config.desktop.doop.enable {
    home.packages = [ packages-nix.packages.${system}.doop ];
  };
}
