{
  pkgs,
  config,
  root,
  ...
}:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "${root}/wallpapers/2880x1920/water.png"
      ];
      wallpaper = [
        ",${root}/wallpapers/2880x1920/water.png"
      ];
    };
  };
}
