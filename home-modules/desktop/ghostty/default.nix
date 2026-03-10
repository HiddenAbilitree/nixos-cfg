{
  config,
  lib,
  ...
}: {
  options.desktop.ghostty.enable = lib.mkEnableOption "Ghostty";

  config = lib.mkIf config.desktop.ghostty.enable {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        font-family = "0xProto Nerd Font";
        theme = "TokyoNight Storm";
        gtk-single-instance = true;
        window-decoration = false;
        background-opacity = 0.5;
        font-size = 11;
      };
    };
  };
}
