{
  config,
  lib,
  nixvim-cfg,
  pkgs,
  ...
}:
{
  options.shell.nvim = {
    enable = lib.mkEnableOption "nvim";
    cloak.enable = lib.mkEnableOption "cloak.nvim" // {
      default = true;
    };
  };

  config = lib.mkIf config.shell.nvim.enable (
    let
      nvim = nixvim-cfg.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in
    {
      home.packages = [
        (nvim.extend {
          plugins = {
            cloak.enable = lib.mkForce config.shell.nvim.cloak.enable;
            vimtex = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
              settings.view_method = lib.mkForce "general";
              zathuraPackage = null;
            };
          };
        })
      ];
    }
  );
}
