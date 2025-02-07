{root, ...}: {
  services.hyprpaper = {
    settings = {
      preload = [
        "${root}/assets/wallpapers/1920x1080/mount_fuji.png"
      ];
      wallpaper = [
        ",${root}/assets/wallpapers/1920x1080/mount_fuji.png"
      ];
    };
  };
}
