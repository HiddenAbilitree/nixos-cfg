{
  config,
  lib,
  ...
}: {
  programs.ghostty = lib.mkIf config.desktop.ghostty.enable {
    enable = true;
    # clearDefaultKeybinds = true;
    enableZshIntegration = true;
    settings = {
      font-family = "MonoLisa Aria";
      theme = "TokyoNight Storm";
      # gtk-adwaita = true;
      gtk-single-instance = true;
      window-decoration = false;
      # window-padding-x = 20;
      # window-padding-y = 20;
      background-opacity = 0.5;
      font-size = 11;
      # keybind = [
      #   "ctrl+shift+t=new_tab"
      #   "ctrl+tab=next_tab"
      #   "ctrl+shift+tab=previous_tab"
      #
      #   "super+1=goto_tab 1"
      #   "super+2=goto_tab 2"
      #   "super+3=goto_tab 3"
      #   "super+4=goto_tab 4"
      #   "super+5=goto_tab 5"
      #   "super+6=goto_tab 6"
      #   "super+7=goto_tab 7"
      #   "super+8=goto_tab 8"
      #   "super+9=goto_tab 9"
      # ];
    };
  };
}
