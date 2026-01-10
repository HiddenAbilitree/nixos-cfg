{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./brave
    ./games
    ./ghostty
    ./gtk
    ./hyprland
    ./kitty
    ./mpv
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
  ];
  options.desktop = {
    enable = lib.mkEnableOption "desktop configuration";
    browser.enable = lib.mkEnableOption "Browser";
    cava.enable = lib.mkEnableOption "Cava";
    dark-mode.enable = lib.mkEnableOption "Dark Mode";
    wallpaper.enable = lib.mkEnableOption "Wallpaper";
    games = {
      enable = lib.mkEnableOption "Games";
      lutris.enable = lib.mkEnableOption "lutris";
      minecraft.enable = lib.mkEnableOption "Minecraft";
      osu.enable = lib.mkEnableOption "osu!";
      roblox.enable = lib.mkEnableOption "Roblox";
      emulators.enable = lib.mkEnableOption "emulators";
    };
    ghostty.enable = lib.mkEnableOption "Ghostty";
    hyprland = {
      enable = lib.mkEnableOption "Hyprland";
      hyprlock.enable = lib.mkEnableOption "Hyprlock";
      hypridle.enable = lib.mkEnableOption "Hypridle";
      hyprpaper.enable = lib.mkEnableOption "Hyprpaper";
    };
    kitty.enable = lib.mkEnableOption "Kitty";
    mpv.enable = lib.mkEnableOption "mpv";
    obs.enable = lib.mkEnableOption "obs";
    rofi.enable = lib.mkEnableOption "Rofi";
    spicetify.enable = lib.mkEnableOption "Spicetify";
    notifications.enable = lib.mkEnableOption "Notifications";
    tor-browser.enable = lib.mkEnableOption "Tor Browser";
    vicinae.enable = lib.mkEnableOption "Vicinae";
    vscodium.enable = lib.mkEnableOption "VSCodium";
    waybar.enable = lib.mkEnableOption "Waybar";
    zathura.enable = lib.mkEnableOption "Zathura";
    zed.enable = lib.mkEnableOption "Zed Editor";
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
      notifications.enable = lib.mkDefault true;
      tor-browser.enable = lib.mkDefault true;
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
