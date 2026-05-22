{
  imports = [./hyprpaper];
  wayland.windowManager.hyprland.extraConfig = builtins.readFile ./hyprland.lua;
}
