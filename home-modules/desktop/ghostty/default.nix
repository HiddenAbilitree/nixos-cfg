{
  config,
  lib,
  pkgs,
  ...
}: {
  options.desktop.ghostty.enable = lib.mkEnableOption "Ghostty";

  config = lib.mkIf config.desktop.ghostty.enable {
    home.sessionVariables = lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
      TERMINAL = "ghostty";
    };

    programs.ghostty =
      {
        enable = true;
        enableZshIntegration = true;
        settings =
          {
            font-family = "0xProto Nerd Font";
            font-size = 11;
            theme = "TokyoNight Storm";
          }
          // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
            background-opacity = 0.9;
            macos-titlebar-style = "tabs";
          }
          // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
            gtk-single-instance = true;
            window-decoration = false;
            background-opacity = 0.5;
          };
      }
      // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
        package = null;
      };
  };
}
