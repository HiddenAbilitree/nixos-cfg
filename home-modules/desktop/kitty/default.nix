{
  config,
  lib,
  ...
}: {
  programs.kitty = lib.mkIf config.desktop.kitty.enable {
    enable = true;
    font = {
      name = "FiraCode";
    };
    themeFile = "tokyo_night_storm";
    settings = {
      background_opacity = ".95";
      enable_audio_bell = false;
      cursor_shape = "beam";
      window_margin_width = "20";
      cursor_trail = 3;
    };
  };
}
