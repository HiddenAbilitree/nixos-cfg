{
  config,
  lib,
  ...
}:
lib.mkIf config.desktop.games.moe.honkers.enable {
  services.flatpak = {
    packages = [
      {
        appId = "moe.launcher.the-honkers-railway-launcher";
        origin = "launcher.moe";
      }
    ];
  };

  desktop.games.moe.enable = lib.mkForce true;
  misc.flatpak.enable = lib.mkDefault true;
  # home.packages = let
  #   aagl-gtk-on-nix = import (builtins.fetchTarball {
  #     url = "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz";
  #     sha256 = "1j4lppqrlg2vkvw601igrs85f1dnvrs401879mvgzdnp6a31sq8n";
  #   });
  # in
  #   [aagl-gtk-on-nix.the-honkers-railway-launcher]
  #   ++ (with pkgs.gst_all_1; [
  #     gst-libav
  #     gst-plugins-good
  #     gst-plugins-bad
  #     gst-plugins-base
  #   ]);
}
