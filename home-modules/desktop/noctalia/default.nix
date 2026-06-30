{
  config,
  osConfig,
  lib,
  ...
}: let
  fujiWallpaper = ../../../assets/wallpapers/1920x1080/mount_fuji.png;
in {
  options.desktop.noctalia = {
    enable = lib.mkEnableOption "noctalia";

    wallpaper = lib.mkOption {
      type = lib.types.path;
      default = fujiWallpaper;
      description = "Wallpaper to use for Noctalia.";
    };
  };

  config = lib.mkIf config.desktop.noctalia.enable {
    programs.noctalia = {
      enable = true;
      customPalettes.tokyo-night-storm = builtins.fromJSON (builtins.readFile ./tokyo-night-storm.json);
      settings = {
        theme = {
          mode = "dark";
          source = "custom";
          custom_palette = "tokyo-night-storm";
        };

        dock.enabled = false;
        desktop_widgets.enabled = false;

        wallpaper = {
          enabled = true;
          default.path = "${config.desktop.noctalia.wallpaper}";
        };

        bar.main = {
          position = "top";
          thickness = 30;
          margin_ends = 4;
          margin_edge = 4;
          border = "#4d5fc2";
          border_width = 2.0;
          radius = 8;
          padding = 10;
          widget_spacing = 6;
          shadow = true;
          capsule = false;

          start = [
            "control-center"
            "workspaces"
          ];
          center = [];
          end =
            [
              "cpu"
              "temp"
              "ram"
              "network"
              "clock"
            ]
            ++ lib.optionals osConfig.laptop.enable [
              "battery"
              "power_profile"
            ];
        };

        widget = {
          workspaces = {
            hide_when_empty = false;
            display = "none";
          };
          cpu.display = "text";
          temp.display = "text";
          ram.display = "text";
          network.show_label = false;
          clock = {
            format = "{:%-I:%M %p}";
            vertical_format = "{:%-I\n%M}";
            color = "primary";
          };
        };

        system.monitor = {
          enabled = true;
          gpu_poll_seconds = 5.0;
        };

        shell = {
          corner_radius_scale = 0.2;
          show_location = false;
          shadow.direction = "center";
          screen_corners = {
            enabled = true;
            # Hyprland windows use gaps_out = 4 and rounding = 8, so the
            # screen corner radius is 4 + 8 for concentric outer corners.
            size = 12;
          };
          panel = {
            transparency_mode = "glass";
            shadow = true;
            control_center_placement = "centered";
          };
        };

        location.auto_locate = true;
        weather = {
          enabled = true;
          unit = "imperial";
        };
      };
    };
  };
}
