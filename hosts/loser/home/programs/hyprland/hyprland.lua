hl.monitor({ output = "eDP-1", mode = "highrr", position = "0x0", scale = "2" })

hl.config({
  general = {
    allow_tearing = true,
  },
  input = {
    touchpad = {
      disable_while_typing = false,
      clickfinger_behavior = false, -- 1 finger : m1, 2 fingers : m2, 3 fingers : m3
    },
  },
  xwayland = {
    force_zero_scaling = true,
  },
  gestures = {
    -- workspace_swipe = true,
    -- workspace_swipe_fingers = 3,
    workspace_swipe_distance = 200,
    workspace_swipe_min_speed_to_force = 0,
    workspace_swipe_create_new = false,
    workspace_swipe_cancel_ratio = 0.5,
    workspace_swipe_forever = true,
    workspace_swipe_direction_lock = false,
  },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

hl.window_rule({ name = "loser-vivaldi-workspace", match = { initial_class = "vivaldi-stable" }, workspace = "1" })
hl.window_rule({ name = "loser-brave-workspace", match = { initial_class = "[bB]rave-browser" }, workspace = "1" })
hl.window_rule({ name = "loser-helium-workspace", match = { initial_class = "helium" }, workspace = "1" })
hl.window_rule({ name = "loser-firefox-workspace", match = { initial_class = "firefox" }, workspace = "1" })
hl.window_rule({ name = "loser-codium-workspace", match = { initial_class = ".*codium.*" }, workspace = "2" })
hl.window_rule({ name = "loser-lunar-workspace", match = { initial_class = ".*[lL]unar.*" }, workspace = "2 silent" })
hl.window_rule({ name = "loser-lunar-immediate", match = { initial_class = ".*[lL]unar.*" }, immediate = true })
hl.window_rule({ name = "loser-steam-workspace", match = { initial_class = ".*steam.*" }, workspace = "2 silent" })
hl.window_rule({ name = "loser-zed-workspace", match = { initial_class = ".*zed.*" }, workspace = "2 silent" })
hl.window_rule({ name = "loser-minecraft-workspace", match = { initial_class = ".*Minecraft.*" }, workspace = "2 silent" })
hl.window_rule({ name = "loser-prism-workspace", match = { initial_class = ".*prism.*" }, workspace = "2 silent" })
hl.window_rule({ name = "loser-kitty-workspace", match = { initial_class = "kitty" }, workspace = "3" })
hl.window_rule({ name = "loser-vesktop-workspace", match = { initial_class = "vesktop" }, workspace = "4" })
hl.window_rule({ name = "loser-spotify-workspace", match = { initial_class = "[Ss]potify" }, workspace = "9" })
