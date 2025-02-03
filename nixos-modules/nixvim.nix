{
  lib,
  config,
  system,
  nixvim-cfg,
  ...
}:
# lib.mkIf config.shell.nvim.enable
{environment.systemPackages = [nixvim-cfg.packages.${system}.default];}
