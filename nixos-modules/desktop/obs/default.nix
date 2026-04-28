{
  config,
  lib,
  pkgs,
  ...
}: let
  obsBasePackage = pkgs.symlinkJoin {
    name = "obs-studio-amd-dcc-workaround";
    paths = [pkgs.obs-studio];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/obs \
        --set AMD_DEBUG nodcc
    '';
  };
in {
  options.desktop.obs.enable = lib.mkEnableOption "obs";

  config = lib.mkIf config.desktop.obs.enable {
    programs.obs-studio = {
      enable = true;
      package = obsBasePackage;
      enableVirtualCamera = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-pipewire-audio-capture
        obs-vaapi
        obs-gstreamer
        obs-vkcapture
      ];
    };
  };
}
