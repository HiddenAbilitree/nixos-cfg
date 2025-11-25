{
  config,
  lib,
  ...
}: {
  services.hypridle = lib.mkIf config.desktop.hyprland.hypridle.enable {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "hyprlock";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 120;
          on-timeout = "hyprlock";
        }
        {
          timeout = 150;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
