{config, ...}: {
  programs.kitty = {
    inherit (config.desktop.kitty) enable;
    font.name = "0xProto Nerd Font";

    themeFile = "tokyo_night_storm";

    settings = {
      # background_opacity = "0.6";
      background_opacity = "1";
      enable_audio_bell = false;
      cursor_shape = "beam";
      window_margin_width = "5";
      cursor_trail = 3;
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_bar_edge = "bottom";
      tab_bar_align = "left";
      active_tab_font_style = "bold";
      inactive_tab_font_style = "normal";
    };
  };
}
