{
  pkgs,
  config,
  ...
}:
{
  programs.mpv = {
    inherit (config.desktop.mpv) enable;
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
}
