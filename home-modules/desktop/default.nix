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
    ./packages
    ./rofi
    ./spicetify
    ./swaync
    ./tor
    ./vscodium
    ./waybar
    ./zathura
  ];
  options.desktop = {
    enable = lib.mkEnableOption "desktop configuration";
    brave.enable = lib.mkEnableOption "Brave Browser";
    dark-mode.enable = lib.mkEnableOption "Dark Mode";
    games = {
      enable = lib.mkEnableOption "Games";
      lutris.enable = lib.mkEnableOption "lutris";
      minecraft.enable = lib.mkEnableOption "Minecraft";
      osu.enable = lib.mkEnableOption "osu!";
      roblox.enable = lib.mkEnableOption "Roblox";
      honkers.enable = lib.mkEnableOption "Honkers";
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
    rofi.enable = lib.mkEnableOption "Rofi";
    spicetify.enable = lib.mkEnableOption "Spicetify";
    swaync.enable = lib.mkEnableOption "Swaync";
    tor-browser.enable = lib.mkEnableOption "Tor Browser";
    vscodium.enable = lib.mkEnableOption "VSCodium";
    waybar.enable = lib.mkEnableOption "Waybar";
    zathura.enable = lib.mkEnableOption "Zathura";
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
      brave.enable = lib.mkDefault true;
      dark-mode.enable = lib.mkDefault true;
      ghostty.enable = lib.mkDefault true;
      hyprland = {
        enable = lib.mkDefault true;
        hyprlock.enable = lib.mkDefault true;
        hypridle.enable = lib.mkDefault true;
        hyprpaper.enable = lib.mkDefault true;
      };
      kitty.enable = lib.mkDefault true;
      rofi.enable = lib.mkDefault true;
      spicetify.enable = lib.mkDefault true;
      swaync.enable = lib.mkDefault true;
      tor-browser.enable = lib.mkDefault true;
      vscodium.enable = lib.mkDefault true;
      waybar.enable = lib.mkDefault true;
      zathura.enable = lib.mkDefault true;
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
