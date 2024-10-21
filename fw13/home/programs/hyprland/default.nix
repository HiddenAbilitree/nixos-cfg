{
  config,
  pkgs,
  ...
}:
{
  wayland.windowManager = {
    hyprland = {
      enable = true;
      extraConfig = builtins.readFile ./hyprland.conf;
      settings = {
        "$menu" = "rofi -show drun";
        "$mod" = "SUPER";
        "$browser" = "brave";
        "$terminal" = "kitty";

        bind = builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = i + 1;
            in
            [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          ) 9
        );
      };
    };
  };
}
