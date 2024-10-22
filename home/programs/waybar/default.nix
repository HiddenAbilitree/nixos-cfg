{
  nixosConfig,
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.waybar = {
    enable = true;
    settings = [
      {
        reload_on_style_change = true;
        layer = "top";
        position = "top";
        modules-left = [
          "custom/launcher"
          "custom/spacer"
          "hyprland/workspaces"
        ];
        modules-center = [

        ];
        modules-right = [
          "tray"
          "network"
          "pulseaudio"
          "group/hardware"
          "clock"
          "battery"
        ];
        battery = {
          format = "{icon} {capacity}%";
          format-icons = [
            "󰂎"
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          states = {
            warning = 30;
            critical = 15;
          };
        };
        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };
        "group/hardware" = {
          orientation = "horizontal";
          modules = [
            "temperature"
            "cpu"
            "memory"
            "disk"
          ];
          drawer = { };
        };
        temperature = {
          format = "{icon} {temperatureC}°C";
          format-icons = [
            ""
            ""
            ""
            ""
          ];
          tooltip = false;
        };
        privacy = {
          icon-spacing = 4;
          icon-size = 18;
          transition-duration = 250;
          modules = [
            {
              type = "screenshare";
              tooltip = true;
              tooltip-icon-size = 24;
            }
            {
              type = "audio-out";
              tooltip = true;
              tooltip-icon-size = 24;
            }
            {
              type = "audio-in";
              tooltip = true;
              tooltip-icon-size = 24;
            }
          ];
        };
        "custom/spacer" = {
          format = "";
        };
        "custom/launcher" = {
          format = " ";
          on-click = "pkill rofi";
          on-click-middle = "exec default_wall";
          on-click-right = "exec wallpaper_random";
          tooltip = false;
        };
        "custom/cava-internal" = {
          exec = "sleep 1s && cava-internal";
          tooltip = false;
        };
        "hyprland/window" = {
          format = "{initialTitle}";
        };
        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            active = "";
            persistent = "";
            empty = "";
          };
          "persistent-workspaces" =
            if nixosConfig.networking.hostName == "loser" then
              {
                "*" = 9;
              }
            else
              {
                "DP-1" = [
                  11
                  12
                  13
                  14
                  15
                  16
                  17
                  18
                  19
                ];
                "DP-2" = [
                  1
                  2
                  3
                  4
                  5
                  6
                  7
                  8
                  9
                ];
              };
        };
        pulseaudio = {
          scroll-step = 1;
          format = "{icon}";
          format-muted = "󰖁";
          format-icons = {
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          tooltip = true;
          tooltip-format = "{volume}%";
        };
        clock = {
          format = " {:%H:%M}";
          format-alt = "  {:%A, %B %d, %Y (%R)}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };
        memory = {
          interval = 1;
          format = " {percentage}%";
          states = {
            warning = 85;
          };
        };
        cpu = {
          interval = 1;
          format = " {usage}%";
        };
        disk = {
          interval = 30;
          format = " {percentage_free}%";
          path = "/";
        };

        mpd = {
          max-length = 25;
          format = "<span foreground='#bb9af7'></span> {title}";
          format-paused = " {title}";
          format-stopped = "<span foreground='#bb9af7'></span>";
          format-disconnected = "";
          on-click = "mpc --quiet toggle";
          on-click-right = "mpc update; mpc ls | mpc add";
          on-click-middle = "kitty --class='ncmpcpp' ncmpcpp ";
          on-scroll-up = "mpc --quiet prev";
          on-scroll-down = "mpc --quiet next";
          smooth-scrolling-threshold = 5;
          tooltip-format = "{title} - {artist} ({elapsedTime:%M:%S}/{totalTime:%H:%M:%S})";
        };
        network = {
          format-disconnected = "󰯡";
          format-ethernet = "";
          format-linked = "󱚵 (No IP)";
          format-wifi = "{icon}";
          format-icons = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          on-click = "nmtui";
          interval = 1;
          tooltip = true;
          tooltip-format = "{essid}";
        };
        tray = {
          icon-size = 15;
          spacing = 5;
        };
      }
    ];
    style = builtins.readFile ./style.css;
  };
}
