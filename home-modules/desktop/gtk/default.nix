{
  config,
  lib,
  packages-nix,
  pkgs,
  ...
}:
{
  options.desktop.dark-mode.enable = lib.mkEnableOption "Dark Mode";

  config = lib.mkIf config.desktop.dark-mode.enable {
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

    gtk = {
      enable = true;

      iconTheme = {
        name = "Papirus";
        package = pkgs.papirus-icon-theme;
      };

      theme = {
        name = "Tokyonight-Dark-Storm";
        package = packages-nix.packages.${pkgs.stdenv.hostPlatform.system}.tokyonight-gtk-theme;
      };

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };

      gtk4 = {
        extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };
        theme = config.gtk.theme;
      };
    };
  };
}
