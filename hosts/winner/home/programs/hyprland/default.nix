{
  config,
  lib,
  ...
}:
let
  monitors = config.desktop.monitors;
  primaryMonitor = builtins.getAttr monitors.primary monitors;
  workspaceCount = 9;
  appRules = [
    {
      name = "winner-vivaldi-workspace";
      class = "vivaldi-stable";
      band = "primary";
      slot = 1;
    }
    {
      name = "winner-helium-workspace";
      class = "helium";
      band = "primary";
      slot = 1;
    }
    {
      name = "winner-brave-workspace";
      class = ".*[bB]rave.*";
      band = "primary";
      slot = 1;
      silent = true;
    }
    {
      name = "winner-firefox-workspace";
      class = "firefox";
      band = "primary";
      slot = 1;
    }
    {
      name = "winner-codium-workspace";
      class = ".*codium.*";
      band = "primary";
      slot = 2;
    }
    {
      name = "winner-lunar-workspace";
      class = ".*[lL]unar.*";
      band = "primary";
      slot = 2;
      silent = true;
    }
    {
      name = "winner-lunar-immediate";
      class = ".*[lL]unar.*";
      immediate = true;
    }
    {
      name = "winner-steam-workspace";
      class = ".*steam.*";
      band = "primary";
      slot = 2;
      silent = true;
    }
    {
      name = "winner-zed-workspace";
      class = ".*zed.*";
      band = "primary";
      slot = 2;
      silent = true;
    }
    {
      name = "winner-minecraft-workspace";
      class = ".*Minecraft.*";
      band = "primary";
      slot = 2;
      silent = true;
    }
    {
      name = "winner-prism-workspace";
      class = ".*prism.*";
      band = "primary";
      slot = 2;
      silent = true;
    }
    {
      name = "winner-steam-game-workspace";
      class = "steam_app.*";
      band = "primary";
      slot = 2;
      silent = true;
    }
    {
      name = "winner-kitty-workspace";
      class = "kitty";
      band = "primary";
      slot = 3;
    }
    {
      name = "winner-vesktop-workspace";
      class = "vesktop";
      band = "secondary";
      slot = 1;
    }
    {
      name = "winner-obs-workspace";
      class = "com.obsproject.Studio";
      band = "secondary";
      slot = 8;
    }
    {
      name = "winner-spotify-workspace";
      class = "[Ss]potify";
      band = "secondary";
      slot = 9;
    }
  ];
  bandWorkspace = rule: (if rule.band == "primary" then 0 else workspaceCount) + rule.slot;
  emitRule =
    rule:
    if rule.immediate or false then
      ''hl.window_rule({ name = "${rule.name}", match = { initial_class = "${rule.class}" }, immediate = true })''
    else
      let
        workspace = "${toString (bandWorkspace rule)}${
          lib.optionalString (rule.silent or false) " silent"
        }";
      in
      ''hl.window_rule({ name = "${rule.name}", match = { initial_class = "${rule.class}" }, workspace = "${workspace}" })'';
  appRuleConfig = lib.concatStringsSep "\n" (map emitRule appRules);
  spotifyWorkspace = toString (
    bandWorkspace (
      builtins.head (builtins.filter (rule: rule.name == "winner-spotify-workspace") appRules)
    )
  );
in
{
  imports = [ ./hyprpaper ];
  wayland.windowManager.hyprland = {
    extraConfig = ''
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
    + ''

      ${appRuleConfig}
      hl.bind("SUPER + s", hl.dsp.focus({ workspace = "${spotifyWorkspace}" }))
      hl.on("hyprland.start", function()
        hl.exec_cmd("obs && obs-cmd --websocket obsws://10.100.0.3:4455/${config.obs-ws-pw} replay start")
      end)

      hl.bind("CTRL + ALT + s", hl.dsp.exec_cmd("obs-cmd --websocket obsws://10.100.0.3:4455/${config.obs-ws-pw} replay save"))
      hl.bind("CTRL + ALT + j", hl.dsp.exec_cmd("obs-cmd --websocket obsws://10.100.0.3:4455/${config.obs-ws-pw} recording start"))
      hl.bind("CTRL + ALT + k", hl.dsp.exec_cmd("obs-cmd --websocket obsws://10.100.0.3:4455/${config.obs-ws-pw} recording stop"))
    '';
  };
}
