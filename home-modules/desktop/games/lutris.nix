{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = lib.mkIf config.desktop.games.lutris.enable (
    with pkgs; [
      (lutris.override {
        extraPkgs = pkgs: [corefonts];
      })
    ]
  );
}
