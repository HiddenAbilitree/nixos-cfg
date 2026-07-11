{
  config,
  lib,
  nixvim-cfg,
  pkgs,
  ...
}: {
  options.shell.nvim.enable = lib.mkEnableOption "nvim";

  config = lib.mkIf config.shell.nvim.enable (let
    nvim = nixvim-cfg.packages.${pkgs.stdenv.hostPlatform.system}.default;
  in {
    home.packages = [
      (
        if pkgs.stdenv.hostPlatform.isDarwin
        then
          nvim.extend {
            plugins.vimtex = {
              settings.view_method = lib.mkForce "general";
              zathuraPackage = null;
            };
          }
        else nvim
      )
    ];
  });
}
