{ config, ... }:
let
  monitors = config.desktop.monitors;
  primaryMonitor = builtins.getAttr monitors.primary monitors;
in
{
  imports = [ ./hyprpaper ];
  wayland.windowManager.hyprland = {
    extraConfig =
      ''
        hl.config({
          general = {
            allow_tearing = false,
          },
          cursor = {
            no_hardware_cursors = 1,
            default_monitor = "${primaryMonitor}",
          },
        })

        hl.monitor({ output = "${monitors.left}", mode = "highrr", position = "0x0", scale = "1" })
        hl.monitor({ output = "${monitors.right}", mode = "highrr", position = "2560x0", scale = "1" })
      ''
      + builtins.readFile ./hyprland.lua
      + ''
        hl.on("hyprland.start", function()
          hl.exec_cmd("obs && obs-cmd --websocket obsws://10.100.0.3:4455/${config.obs-ws-pw} replay start")
        end)

        hl.bind("CTRL + ALT + s", hl.dsp.exec_cmd("obs-cmd --websocket obsws://10.100.0.3:4455/${config.obs-ws-pw} replay save"))
        hl.bind("CTRL + ALT + j", hl.dsp.exec_cmd("obs-cmd --websocket obsws://10.100.0.3:4455/${config.obs-ws-pw} recording start"))
        hl.bind("CTRL + ALT + k", hl.dsp.exec_cmd("obs-cmd --websocket obsws://10.100.0.3:4455/${config.obs-ws-pw} recording stop"))
      '';
  };
}
