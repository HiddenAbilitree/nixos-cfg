{
  lib,
  config,
  system,
  nixvim-cfg,
  ...
}:
lib.mkIf config.shell.nvim.enable { home.packages = [ nixvim-cfg.packages.${system}.default ]; }
