{
  config,
  lib,
  pkgs,
  ...
}: {
  options.desktop.obs.enable = lib.mkEnableOption "obs";

  config = lib.mkIf config.desktop.obs.enable {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-pipewire-audio-capture
        obs-vaapi
        obs-gstreamer
        obs-vkcapture
      ];
    };
  };
}
