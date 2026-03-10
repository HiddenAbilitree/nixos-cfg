{
  config,
  lib,
  ...
}: {
  options.desktop.wallpaper.enable = lib.mkEnableOption "Wallpaper";

  config = lib.mkIf config.desktop.wallpaper.enable {
    programs.mpvpaper.enable = true;
  };
}
