{
  config,
  lib,
  noctalia,
  pkgs,
  ...
}: {
  imports = [
    ./brave
    ./cava
    ./games
    ./ghostty
    ./gtk
    ./hyprland
    ./kitty
    ./mpv
    ./noctalia
    ./notifications
    ./obs
    ./packages
    ./rofi
    ./spicetify
    ./vicinae
    ./vscodium
    ./wallpaper
    ./waybar
    ./zathura
    ./zed

    noctalia.homeModules.default
  ];

  options.desktop = {
    enable = lib.mkEnableOption "desktop configuration";
    primary-monitor = lib.mkOption {
      type = lib.types.str;
      description = "primary monitor";
    };
  };

  config = lib.mkIf config.desktop.enable {
    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    services.clipman.enable = true;

    desktop = {
      browser.enable = lib.mkDefault true;
      cava.enable = lib.mkDefault true;
      dark-mode.enable = lib.mkDefault true;
      ghostty.enable = lib.mkDefault true;
      hyprland = {
        enable = lib.mkDefault true;
        hyprlock.enable = lib.mkDefault true;
        hyprpaper.enable = lib.mkDefault true;
        hypridle.enable = lib.mkDefault true;
      };
      kitty.enable = lib.mkDefault true;
      mpv.enable = lib.mkDefault true;
      obs.enable = lib.mkDefault true;
      rofi.enable = lib.mkDefault true;
      spicetify.enable = lib.mkDefault true;
      noctalia.enable = lib.mkDefault false;
      notifications.enable = lib.mkDefault true;
      vicinae.enable = lib.mkDefault true;
      vscodium.enable = lib.mkDefault true;
      waybar.enable = lib.mkDefault true;
      zathura.enable = lib.mkDefault true;
      zed.enable = lib.mkDefault false;
      wallpaper.enable = lib.mkDefault true;
    };

    xdg.mimeApps.defaultApplications = {
      "application/pdf" = ["zathura"];
      "text/plain" = ["kitty"];
      "text/html" = ["brave"];
      "image/png" = ["brave"];
      "image/jpeg" = ["brave"];
      "image/gif" = ["brave"];
    };
  };
}
