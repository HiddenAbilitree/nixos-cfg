{
  lib,
  config,
  nixvim-cfg,
  pkgs,
  ...
}:
lib.mkIf config.shell.nvim.enable {
  home.packages = [nixvim-cfg.packages.${pkgs.stdenv.hostPlatform.system}.default];
}
