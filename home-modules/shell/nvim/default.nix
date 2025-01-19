{
  lib,
  config,
  system,
  nixvim-cfg,
  nixpkgs,
  ...
}: let
  pkgs = import nixpkgs {
    inherit system;
    overlays = [
      (final: prev: {
        neovim = nixvim-cfg.packages.${system}.default;
      })
    ];
  };
in
  lib.mkIf config.shell.nvim.enable {
    home.packages = with pkgs; [
      neovim
    ];
  }
