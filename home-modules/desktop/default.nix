{
  lib,
  config,
  ...
}: {
  imports = [
    ./brave
    ./dark-mode
    ./games
    ./ghostty
    ./kitty
    ./rofi
    ./zathura
    ./swaync
    ./packages
    ./hyprland
    ./waybar
    ./spicetify
  ];
  options.desktop = {
    enable = lib.mkEnableOption "desktop configuration";
    dark-mode.enable = lib.mkEnableOption "Dark Mode";
    brave.enable = lib.mkEnableOption "Brave Browser";
    games = {
      enable = lib.mkEnableOption "Games";
      osu.enable = lib.mkEnableOption "osu!";
      roblox.enable = lib.mkEnableOption "Roblox";
    };
    ghostty.enable = lib.mkEnableOption "Ghostty";
    kitty.enable = lib.mkEnableOption "Kitty";
    rofi.enable = lib.mkEnableOption "Rofi";
    waybar.enable = lib.mkEnableOption "Waybar";
    spicetify.enable = lib.mkEnableOption "Spicetify";
    swaync.enable = lib.mkEnableOption "Swaync";
    zathura.enable = lib.mkEnableOption "Zathura";
    hyprland = {
      enable = lib.mkEnableOption "Hyprland";
      hyprlock.enable = lib.mkEnableOption "Hyprlock";
      hypridle.enable = lib.mkEnableOption "Hypridle";
      hyprpaper.enable = lib.mkEnableOption "Hyprpaper";
    };
  };

  config = {
    desktop = lib.mkIf config.desktop.enable {
      brave.enable = lib.mkDefault true;
      dark-mode.enable = lib.mkDefault true;
      games = {
        enable = lib.mkDefault true;
        osu.enable = lib.mkDefault true;
        roblox.enable = lib.mkDefault true;
      };
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
