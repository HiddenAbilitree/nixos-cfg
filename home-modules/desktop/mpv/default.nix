{
  config,
  lib,
  pkgs,
  ...
}: {
  options.desktop.mpv.enable = lib.mkEnableOption "mpv";

  config = lib.mkIf config.desktop.mpv.enable {
    programs.mpv =
      {enable = true;}
      // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
        config = {
          border = "no";
          osd-bar = "no";
        };
        includes = [
          "mpv.conf"
        ];
        scripts = with pkgs.mpvScripts; [
          inhibit-gnome
          thumbfast
          uosc
        ];
      };
  };
}
