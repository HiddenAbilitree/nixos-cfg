local menu = "rofi -show drun"
local mod = "SUPER"
local browser = "brave"
local terminal = "kitty"
local split_workspace_count = 9

local function on_start(commands)
  hl.on("hyprland.start", function()
    for _, command in ipairs(commands) do
      hl.exec_cmd(command)
    end
  end)
end

local function bind_exec(keys, command, flags)
  hl.bind(keys, hl.dsp.exec_cmd(command), flags)
end

local function split_monitors()
  local monitors = {}
  for _, monitor in ipairs(hl.get_monitors()) do
    if not monitor.is_mirror then
      table.insert(monitors, monitor)
    end
  end

  return monitors
end

local function current_monitor()
  return hl.get_active_monitor() or hl.get_monitor_at_cursor()
end

local function split_change_monitor(direction)
  local monitors = split_monitors()
  local monitor = current_monitor()
  if monitor == nil or #monitors == 0 then
    return
  end

  local current_index = 1
  for index, candidate in ipairs(monitors) do
    if candidate.name == monitor.name then
      current_index = index
      break
    end
  end

  local delta = direction == "prev" and -1 or 1
  local target_index = ((current_index - 1 + delta) % #monitors) + 1
  local workspace = monitors[target_index].active_workspace
  if workspace ~= nil then
    return hl.dispatch(hl.dsp.window.move({ workspace = workspace }))
  end
end

local function bind_split_monitor_workspaces()
  smw.setup({
    workspace_count = split_workspace_count,
    keep_focused = false,
    enable_notifications = true,
    enable_persistent_workspaces = true,
    enable_wrapping = true,
  })

  for workspace = 1, split_workspace_count do
    local key = tostring(workspace)
    hl.bind(mod .. " + " .. key, smw.workspace(key))
    hl.bind(mod .. " + SHIFT + " .. key, smw.move_to_workspace_silent(key))
  end

  hl.bind(mod .. " + z + x + c + v", smw.grab_rogue_windows())
  hl.bind(mod .. " + Right", function()
    return split_change_monitor("next")
  end)
  hl.bind(mod .. " + Left", function()
    return split_change_monitor("prev")
  end)
end

on_start({
  "systemctl --user start hyprpolkitagent",
  "noctalia",
  "vicinae server",
  "vesktop",
  "spotify",
  terminal,
  "btm",
  browser,
  "waybar",
  "hyprpaper",
})

hl.config({
  ecosystem = {
    no_update_news = true,
  },
  general = {
    gaps_in = 2,
    gaps_out = 4,
    border_size = 2,
    col = {
      active_border = "0xff4d5fc2",
    },
    resize_on_border = true,
    extend_border_grab_area = 50,
    hover_icon_on_border = true,
  },
  decoration = {
    rounding = 8,
    inactive_opacity = 1,
    active_opacity = 1,
    shadow = {
      enabled = true,
      range = 4,
      render_power = 3,
      color = "0xee1a1a1a",
    },
    blur = {
      enabled = true,
      size = 3,
      passes = 2,
      vibrancy = 0.1696,
    },
  },
  misc = {
    disable_hyprland_logo = true,
    focus_on_activate = true,
  },
  input = {
    kb_layout = "us, us(colemak_dh)",
    kb_options = "grp:alt_altgr_toggle",
    repeat_rate = 50,
    repeat_delay = 300,
    accel_profile = "flat",
  },
  animations = {
    enabled = true,
  },
})

for name, points in pairs({
  linear = { { 0, 0 }, { 1, 1 } },
  md3_standard = { { 0.2, 0 }, { 0, 1 } },
  md3_decel = { { 0.05, 0.7 }, { 0.1, 1 } },
  md3_accel = { { 0.3, 0 }, { 0.8, 0.15 } },
  overshot = { { 0.05, 0.9 }, { 0.1, 1.1 } },
  crazyshot = { { 0.1, 1.5 }, { 0.76, 0.92 } },
  hyprnostretch = { { 0.05, 0.9 }, { 0.1, 1.0 } },
  menu_decel = { { 0.1, 1 }, { 0, 1 } },
  menu_accel = { { 0.38, 0.04 }, { 1, 0.07 } },
  easeInOutCirc = { { 0.85, 0 }, { 0.15, 1 } },
  easeOutCirc = { { 0, 0.55 }, { 0.45, 1 } },
  easeOutExpo = { { 0.16, 1 }, { 0.3, 1 } },
  softAcDecel = { { 0.26, 0.26 }, { 0.15, 1 } },
  md2 = { { 0.4, 0 }, { 0.2, 1 } },
}) do
  hl.curve(name, { type = "bezier", points = points })
end

for _, animation in ipairs({
  { leaf = "windows",          enabled = true, speed = 3,   bezier = "md3_decel",  style = "popin 60%" },
  { leaf = "windowsIn",        enabled = true, speed = 3,   bezier = "md3_decel",  style = "popin 60%" },
  { leaf = "windowsOut",       enabled = true, speed = 3,   bezier = "md3_accel",  style = "popin 60%" },
  { leaf = "border",           enabled = true, speed = 10,  bezier = "default" },
  { leaf = "fade",             enabled = true, speed = 3,   bezier = "md3_decel" },
  { leaf = "layersIn",         enabled = true, speed = 3,   bezier = "menu_decel", style = "slide" },
  { leaf = "layersOut",        enabled = true, speed = 1.6, bezier = "menu_accel" },
  { leaf = "fadeLayersIn",     enabled = true, speed = 2,   bezier = "menu_decel" },
  { leaf = "fadeLayersOut",    enabled = true, speed = 0.5, bezier = "menu_accel" },
  { leaf = "workspaces",       enabled = true, speed = 7,   bezier = "menu_decel", style = "slide" },
  { leaf = "specialWorkspace", enabled = true, speed = 3,   bezier = "md3_decel",  style = "slidevert" },
}) do
  hl.animation(animation)
end

bind_split_monitor_workspaces()

bind_exec(mod .. " + SHIFT + R", "hyprland-reset-window-workspaces")
hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
bind_exec(mod .. " + B", browser)
bind_exec(mod .. " + Q", terminal)
bind_exec(mod .. " + grave", menu)
bind_exec(mod .. " + space", "vicinae toggle")
bind_exec("ALT + Tab", "rofi -show window")
bind_exec("ALT + CTRL + SHIFT + P", "rofi -show filebrowser")
bind_exec(mod .. " + mouse_down", "wpctl set-volume @DEFAULT_SINK@ 0.1-")
bind_exec(mod .. " + mouse_up", "wpctl set-volume @DEFAULT_SINK@ 0.1+")
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(mod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))

for _, binding in ipairs({
  { key = "Left",  direction = "left" },
  { key = "Right", direction = "right" },
  { key = "Up",    direction = "up" },
  { key = "Down",  direction = "down" },
}) do
  hl.bind(mod .. " + SHIFT + " .. binding.key, hl.dsp.window.swap({ direction = binding.direction }))
  hl.bind(mod .. " + " .. binding.key, hl.dsp.window.move({ direction = binding.direction }))
  hl.bind(mod .. " + CTRL + SHIFT + " .. binding.key, hl.dsp.focus({ direction = binding.direction }))
end

bind_exec(mod .. " + l", "hyprlock")
bind_exec(mod .. " + p", "hyprpicker -a -f hex")
bind_exec(mod .. " + SHIFT + S", "hyprshot -m region --clipboard-only --freeze --silent", { locked = true })
bind_exec("Print", "hyprshot -m output -m eDP-1", { locked = true })

for _, binding in ipairs({
  { key = "XF86AudioRaiseVolume",  command = "wpctl set-volume @DEFAULT_SINK@ 0.01+",     repeating = true },
  { key = "XF86AudioLowerVolume",  command = "wpctl set-volume @DEFAULT_SINK@ 0.01-",     repeating = true },
  { key = "XF86MonBrightnessUp",   command = "brightnessctl set 5%+",                     repeating = true },
  { key = "XF86MonBrightnessDown", command = "brightnessctl set 5%-",                     repeating = true },
  { key = "XF86AudioPlay",         command = "playerctl play-pause" },
  { key = "XF86AudioMute",         command = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle" },
  { key = "XF86AudioNext",         command = "playerctl next" },
  { key = "XF86AudioPrev",         command = "playerctl previous" },
}) do
  local flags = { locked = true }
  if binding.repeating == true then
    flags.repeating = true
  end

  bind_exec(binding.key, binding.command, flags)
end
