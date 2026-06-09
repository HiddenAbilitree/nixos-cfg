{
  config,
  osConfig,
  lib,
  ...
}: {
  options.desktop.noctalia.enable = lib.mkEnableOption "noctalia";

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

        bar.main = {
          position = "top";
          thickness = 30;
          margin_ends = 0;
          margin_edge = 4;
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
          panel = {
            transparency_mode = "glass";
            shadow = true;
            control_center_placement = "centered";
          };
        };

        location = {
          auto_locate = false;
          address = "New York, United States";
        };
        weather.unit = "fahrenheit";
      };
    };
  };
}
