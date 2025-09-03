{config, ...}: {
  imports = [./hyprpaper];
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        "CTRL ALT, s, exec, obs-cmd --websocket obsws://10.100.0.3:4455/${config.obs-ws-pw} replay save"
        "CTRL ALT, j, exec, obs-cmd --websocket obsws://10.100.0.3:4455/${config.obs-ws-pw} recording start"
        "CTRL ALT, k, exec, obs-cmd --websocket obsws://10.100.0.3:4455/${config.obs-ws-pw} recording stop"
      ];
    };
    extraConfig = builtins.readFile ./hyprland.conf;
  };
}
