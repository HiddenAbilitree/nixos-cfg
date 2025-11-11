{
  config,
  pkgs,
  ...
}: {
  # services.swww = {
  #   enable = config.desktop.wallpaper.enable;
  #   package = swww.packages.${pkgs.system}.swww;
  # };

  programs.mpvpaper.enable = config.desktop.wallpaper.enable;
}
