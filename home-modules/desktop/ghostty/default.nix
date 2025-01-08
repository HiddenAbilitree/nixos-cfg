{
  config,
  lib,
  ...
}: {
  programs.ghostty = lib.mkIf config.desktop.ghostty.enable {
    enable = true;
    clearDefaultKeybinds = true;
    enableZshIntegration = true;
    settings = {
      font-family = "0xProto Nerd Font";
      theme = "tokyonight-storm";
      gtk-adwaita = false;
      gtk-single-instance = true;
      window-decoration = false;
      # window-padding-x = 20;
      # window-padding-y = 20;
      background-opacity = 0.95;
      font-size = 11;
    };
  };
}
