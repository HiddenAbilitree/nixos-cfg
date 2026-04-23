{
  config,
  lib,
  paper,
  system,
  ...
}: {
  options.desktop.paper.enable = lib.mkEnableOption "Paper design tool";

  config = lib.mkIf config.desktop.paper.enable {
    home.packages = [paper.packages.${system}.default];
  };
}
