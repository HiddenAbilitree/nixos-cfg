{
  config,
  lib,
  ...
}: {
  options.desktop.hyprland.hyprpaper.enable = lib.mkEnableOption "Hyprpaper";

  config = lib.mkIf config.desktop.hyprland.hyprpaper.enable {
    services.hyprpaper.enable = true;
  };
}
