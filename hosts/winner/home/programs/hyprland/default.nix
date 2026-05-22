{config, ...}: {
  imports = [./hyprpaper];
  wayland.windowManager.hyprland = {
    extraConfig =
      builtins.readFile ./hyprland.lua
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
