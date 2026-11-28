{ pkgs, wynn, ... }:
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
    wynn.homeManagerModules.lootpool-refresh
  ];

  shell = {
    enable = true;
    nvim.cloak.enable = false;
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
    inherit monitors;
    primary-monitor = builtins.getAttr monitors.primary monitors;
  };

  misc.enable = true;

  services.wynn-lootpool-refresh.enable = true;

  home.packages = with pkgs; [
    headsetcontrol
  ];
}
