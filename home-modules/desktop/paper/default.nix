{
  config,
  lib,
  packages-nix,
  system,
  ...
}:
{
  options.desktop.paper.enable = lib.mkEnableOption "Paper design tool";

  config = lib.mkIf config.desktop.paper.enable {
    home.packages = [ packages-nix.packages.${system}.paper ];
  };
}
