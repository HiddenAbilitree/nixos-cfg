{
  config,
  lib,
  root,
  ...
}: {
  options.desktop.primary-monitor = lib.mkOption {
    type = lib.types.str;
    description = "primary monitor";
  };

  config.programs.hyprlock = lib.mkIf config.desktop.hyprland.hyprlock.enable {
    enable = true;
    settings = let
      foreground = "rgba(255,255,255,0.8)";
      background = "rgb(36,40,59,1)";
    in {
      background = {
        path = "${root}/assets/wallpapers/2880x1920/water.png";
        blur_passes = 2;
        contrast = 1;
        brightness = 0.5;
        vibrancy = 0.2;
        vibrancy_darkness = 0.2;
      };

      # GENERAL
      general = {
        enable_fingerprint = true;
        no_fade_in = true;
        no_fade_out = true;
        hide_cursor = true;
        grace = 0;
        disable_loading_bar = true;
        ignore_empty_input = true;
      };

      # INPUT FIELD
      input-field = [
        {
          monitor = config.desktop.primary-monitor;
          size = "500, 120";
          outline_thickness = 2;
          dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.35; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true;
          outer_color = "rgba(0, 0, 0, 0)";
          inner_color = "rgba(0,0,0,0.2)";
          font_color = foreground;
          fade_on_empty = false;
          rounding = -1;
          check_color = "rgb(204, 136, 34)";
          placeholder_text = ''<i><span foreground="##cdd6f4">Password...</span></i>'';
          hide_input = false;
          position = "0, -200";
          halign = "center";
          valign = "center";
        }
      ];

      # DATE
      label = [
        {
          monitor = config.desktop.primary-monitor;
          text = ''cmd[update:1000] echo "$(date +"%A, %B %d")"'';
          color = "rgba(242, 243, 244, 0.75)";
          font_size = 30;
          font_family = "JetBrains Mono";
          position = "0, 320";
          halign = "center";
          valign = "center";
        }

        # TIME
        {
          monitor = config.desktop.primary-monitor;
          text = ''cmd[update:1000] echo "$(date +"%-I:%M")"'';
          color = "rgba(242, 243, 244, 0.75)";
          font_size = 120;
          font_family = "JetBrains Mono Extrabold";
          position = "0, 200";
          halign = "center";
          valign = "center";
        }
        # {
        #   monitor = config.desktop.primary-monitor;
        #   text = "Eric Zhang";
        #   color = foreground;
        #   font_size = 14;
        #   font_family = "JetBrains Mono";
        #   position = "0, -10";
        #   halign = "center";
        #   valign = "top";
        # }
      ];

      # Profile Picture

      # image = [
      #   {
      #     path = "${root}/";
      #     size = 100;
      #     border_size = 2;
      #     border_color = foreground;
      #     position = "0, -100";
      #     halign = "center";
      #     valign = "center";
      #   }
      # ];

      # label {
      #     monitor =
      #     text = cmd[update:1000] echo "$(/home/justin/Documents/Scripts/battery.sh)"
      #     color = $foreground
      #     font_size = 24
      #     font_family = JetBrains Mono
      #     position = -90, -10
      #     halign = right
      #     valign = top
      # }

      # label {
      #     monitor =
      #     text = cmd[update:1000] echo "$(/home/justin/Documents/Scripts/network-status.sh)"
      #     color = $foreground
      #     font_size = 24
      #     font_family = JetBrains Mono
      #     position = -20, -10
      #     halign = right
      #     valign = top
      # }
    };
  };
}
