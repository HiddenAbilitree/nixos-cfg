{root, ...}: {
  services.hyprpaper.settings = {
    preload = [
      "${root}/assets/wallpapers/2880x1920/water.png"
      "${root}/assets/wallpapers/2880x1920/redtree.jpg"
    ];
    wallpaper = [
      ",${root}/assets/wallpapers/2880x1920/water.png"
    ];
  };
}
