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
        "${root}/wallpapers/2880x1920/redtree.jpg"
      ];
      wallpaper = [
        ",${root}/wallpapers/2880x1920/water.png"
      ];
    };
  };
}
