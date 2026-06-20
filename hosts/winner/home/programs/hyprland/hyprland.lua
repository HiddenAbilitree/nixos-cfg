hl.config({
  general = {
    allow_tearing = false,
  },
  cursor = {
    no_hardware_cursors = 1,
  },
})

-- hl.monitor({ output = "DP-1", mode = "highrr", position = "0x0", scale = "1" })
-- hl.monitor({ output = "DP-2", mode = "highrr", position = "2560x0", scale = "1" })
--
hl.monitor({ output = "DP-1", mode = "highrr", position = "0x0", scale = "1" })
hl.monitor({ output = "DP-2", mode = "highrr", position = "1920x0", scale = "1" })

-- right side primary
-- hl.window_rule({ name = "winner-right-vivaldi-workspace", match = { initial_class = "vivaldi-stable" }, workspace = "10" })
-- hl.window_rule({ name = "winner-right-brave-workspace", match = { initial_class = "[bB]rave-browser" }, workspace = "10" })
-- hl.window_rule({ name = "winner-right-firefox-workspace", match = { initial_class = "firefox" }, workspace = "10" })
-- hl.window_rule({ name = "winner-right-codium-workspace", match = { initial_class = ".*codium.*" }, workspace = "11" })
-- hl.window_rule({ name = "winner-right-lunar-workspace", match = { initial_class = ".*[lL]unar.*" }, workspace = "11 silent" })
-- hl.window_rule({ name = "winner-right-lunar-immediate", match = { initial_class = ".*[lL]unar.*" }, immediate = true })
-- hl.window_rule({ name = "winner-right-steam-workspace", match = { initial_class = ".*steam.*" }, workspace = "11 silent" })
-- hl.window_rule({ name = "winner-right-zed-workspace", match = { initial_class = ".*zed.*" }, workspace = "11 silent" })
-- hl.window_rule({ name = "winner-right-minecraft-workspace", match = { initial_class = ".*Minecraft.*" }, workspace = "11 silent" })
-- hl.window_rule({ name = "winner-right-prism-workspace", match = { initial_class = ".*prism.*" }, workspace = "11 silent" })
-- hl.window_rule({ name = "winner-right-kitty-workspace", match = { initial_class = "kitty" }, workspace = "12" })
--
-- hl.window_rule({ name = "winner-right-vesktop-workspace", match = { initial_class = "vesktop" }, workspace = "1" })
-- hl.window_rule({ name = "winner-right-obs-workspace", match = { initial_class = "com.obsproject.Studio" }, workspace = "8" })
-- hl.window_rule({ name = "winner-right-spotify-workspace", match = { initial_class = "[Ss]potify" }, workspace = "9" })


-- left side primary
-- hl.window_rule({ name = "winner-left-vivaldi-workspace", match = { initial_class = "vivaldi-stable" }, workspace = "1" })
-- hl.window_rule({ name = "winner-left-helium-workspace", match = { initial_class = "helium" }, workspace = "1" })
-- hl.window_rule({ name = "winner-left-brave-workspace", match = { initial_class = "[bB]rave-browser" }, workspace = "1" })
-- hl.window_rule({ name = "winner-left-firefox-workspace", match = { initial_class = "firefox" }, workspace = "1" })
-- hl.window_rule({ name = "winner-left-codium-workspace", match = { initial_class = ".*codium.*" }, workspace = "2" })
-- hl.window_rule({ name = "winner-left-lunar-workspace", match = { initial_class = ".*[lL]unar.*" }, workspace = "2 silent" })
-- hl.window_rule({ name = "winner-left-lunar-immediate", match = { initial_class = ".*[lL]unar.*" }, immediate = true })
-- hl.window_rule({ name = "winner-left-steam-workspace", match = { initial_class = ".*steam.*" }, workspace = "2 silent" })
-- hl.window_rule({ name = "winner-left-zed-workspace", match = { initial_class = ".*zed.*" }, workspace = "2 silent" })
-- hl.window_rule({ name = "winner-left-minecraft-workspace", match = { initial_class = ".*Minecraft.*" }, workspace = "2 silent" })
-- hl.window_rule({ name = "winner-left-prism-workspace", match = { initial_class = ".*prism.*" }, workspace = "2 silent" })
-- hl.window_rule({ name = "winner-left-steam-game-workspace", match = { initial_class = "steam_app.*" }, workspace = "2 silent" }) -- steam games
-- hl.window_rule({ name = "winner-left-kitty-workspace", match = { initial_class = "kitty" }, workspace = "3" })
--
-- hl.window_rule({ name = "winner-left-vesktop-workspace", match = { initial_class = "vesktop" }, workspace = "10" })
-- hl.window_rule({ name = "winner-left-obs-workspace", match = { initial_class = "com.obsproject.Studio" }, workspace = "17" })
-- hl.window_rule({ name = "winner-left-spotify-workspace", match = { initial_class = "[Ss]potify" }, workspace = "18" })

-- right side primary
hl.window_rule({ name = "winner-vivaldi-workspace", match = { initial_class = "vivaldi-stable" }, workspace = "10" })
hl.window_rule({ name = "winner-helium-workspace", match = { initial_class = "helium" }, workspace = "10" })
hl.window_rule({ name = "winner-brave-workspace", match = { initial_class = ".*[bB]rave.*" }, workspace = "10" })
hl.window_rule({ name = "winner-firefox-workspace", match = { initial_class = "firefox" }, workspace = "10" })
hl.window_rule({ name = "winner-codium-workspace", match = { initial_class = ".*codium.*" }, workspace = "11" })
hl.window_rule({ name = "winner-lunar-workspace", match = { initial_class = ".*[lL]unar.*" }, workspace = "11 silent" })
hl.window_rule({ name = "winner-lunar-immediate", match = { initial_class = ".*[lL]unar.*" }, immediate = true })
hl.window_rule({ name = "winner-steam-workspace", match = { initial_class = ".*steam.*" }, workspace = "11 silent" })
hl.window_rule({ name = "winner-zed-workspace", match = { initial_class = ".*zed.*" }, workspace = "11 silent" })
hl.window_rule({ name = "winner-minecraft-workspace", match = { initial_class = ".*Minecraft.*" }, workspace = "11 silent" })
hl.window_rule({ name = "winner-prism-workspace", match = { initial_class = ".*prism.*" }, workspace = "11 silent" })
hl.window_rule({ name = "winner-steam-game-workspace", match = { initial_class = "steam_app.*" }, workspace = "11 silent" }) -- steam games
hl.window_rule({ name = "winner-kitty-workspace", match = { initial_class = "kitty" }, workspace = "12" })
hl.window_rule({ name = "winner-vesktop-workspace", match = { initial_class = "vesktop" }, workspace = "1" })
hl.window_rule({ name = "winner-obs-workspace", match = { initial_class = "com.obsproject.Studio" }, workspace = "8" })
hl.window_rule({ name = "winner-spotify-workspace", match = { initial_class = "[Ss]potify" }, workspace = "9" })
