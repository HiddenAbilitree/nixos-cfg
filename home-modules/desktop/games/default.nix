{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [./osu.nix ./roblox.nix];
  home.packages = lib.mkIf config.desktop.games.lutris.enable (with pkgs; [
    (lutris.override {
      extraPkgs = pkgs: [corefonts];
    })
  ]);
}
