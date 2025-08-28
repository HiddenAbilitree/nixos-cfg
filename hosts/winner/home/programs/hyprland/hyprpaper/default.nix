{ root, ... }:
{
  services.hyprpaper = {
    settings = let
      bg = "field";
    in {
      preload = [
        # "${root}/assets/wallpapers/1920x1080/mount_fuji.png"
        # "${root}/assets/wallpapers/2560x1440/field.png"
        "${root}/assets/wallpapers/2560x1440/${bg}/right.png"
        "${root}/assets/wallpapers/2560x1440/${bg}/left.png"
      ];
      wallpaper = [
        # ",${root}/assets/wallpapers/1920x1080/mount_fuji.png"
        # "DP-1,${root}/assets/wallpapers/2560x1440/field.png"
        "DP-1,${root}/assets/wallpapers/2560x1440/${bg}/left.png"
        "DP-2,${root}/assets/wallpapers/2560x1440/${bg}/right.png"
      ];
    };
  };
}
