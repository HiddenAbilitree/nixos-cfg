{ pkgs, ... }:
let
  monitors = {
    left = "DP-1";
    right = "DP-2";
    primary = "left";
  };
in
{
  imports = [
    ./programs
  ];

  shell = {
    enable = true;
    zellij.autostart = false;
  };
  desktop = {
    zed.enable = true;
    noctalia.enable = true;
    hyprland = {
      hypridle.enable = false;
      hyprlock.enable = false;
    };
    # wallpaper.enable = true;
    enable = true;
    games = {
      enable = true;
      emulators.enable = true;
      # moe = {
      #   # honkers.enable = true;
      #   aagl.enable = true;
      # };
    };
    monitors = monitors;
    primary-monitor = builtins.getAttr monitors.primary monitors;
  };

  misc.enable = true;

  home.packages = with pkgs; [
    headsetcontrol
  ];
}
