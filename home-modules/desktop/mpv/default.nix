{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.desktop.mpv.enable {
  programs.mpv = {
    enable = true;
    config = {
      border = "no";
      osd-bar = "no";
    };
    scripts = with pkgs.mpvScripts; [
      inhibit-gnome
      thumbfast
      uosc
    ];
  };
}
