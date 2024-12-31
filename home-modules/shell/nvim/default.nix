{
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
in {
  home.packages = with pkgs; [
    neovim
  ];
}
