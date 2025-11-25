{pkgs, ...}: {
  imports = [
    ./programs
  ];

  shell = {
    enable = true;
    zellij.autostart = false;
  };
  desktop = {
    hyprland = {
      hypridle.enable = false;
      hyprlock.enable = false;
    };
    # wallpaper.enable = true;
    enable = true;
    games = {
      enable = true;
      # moe = {
      #   # honkers.enable = true;
      #   aagl.enable = true;
      # };
    };
    primary-monitor = "DP-2";
  };

  misc.enable = true;

  home.packages = with pkgs; [
    headsetcontrol
  ];
}
