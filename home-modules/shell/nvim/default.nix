{
  config,
  lib,
  nixvim-cfg,
  pkgs,
  ...
}: {
  options.shell.nvim.enable = lib.mkEnableOption "nvim";

  config = lib.mkIf config.shell.nvim.enable {
    home.packages = [nixvim-cfg.packages.${pkgs.stdenv.hostPlatform.system}.default];
  };
}
