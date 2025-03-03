{
  pkgs,
  config,
  lib,
  ...
}:
lib.mkIf config.desktop.dark-mode.enable {
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  gtk = {
    enable = true;

    iconTheme = {
      name = "Tokyonight-Dark-Cyan";
      package = pkgs.tokyonight-gtk-theme.override {
        colorVariants = ["dark"];
        tweakVariants = ["storm" "macos" "outline"];
        iconVariants = ["Dark-Cyan"];
      };
    };

    theme = {
      name = "Tokyonight-Dark-Storm";
      package = pkgs.tokyonight-gtk-theme.override {
        colorVariants = ["dark"];
        tweakVariants = ["storm" "macos" "outline"];
        iconVariants = ["Dark-Cyan"];
      };
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
}
