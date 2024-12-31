{root, ...}: {
  services.hyprpaper = {
    settings = {
      preload = [
        "${root}/wallpapers/1920x1080/mount_fuji.png"
      ];
      wallpaper = [
        ",${root}/wallpapers/1920x1080/mount_fuji.png"
      ];
    };
  };
}
