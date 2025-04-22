{
  config,
  lib,
  ...
}: {
  programs.kitty = lib.mkIf config.desktop.kitty.enable {
    enable = true;
    font.name = "0xProto Nerd Font";

    themeFile = "tokyo_night_storm";

    settings = {
      background_opacity = ".95";
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

    # extraConfig = ''
    #   font_family      family='MonoLisa Aria'
    #   bold_font        auto
    #   italic_font      auto
    #   bold_italic_font auto
    #
    #   font_features MonoLisa-Italic +ss02
    #
    #   font_features MonoLisa-Medium +zero +ss04 +ss07 +ss08 +ss09
    #   font_features MonoLisa-MediumItalic +zero +ss04 +ss07 +ss08 +ss09
    # '';
  };
}
