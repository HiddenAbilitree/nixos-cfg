{pkgs, ...}: {
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
    primary-monitor = "DP-2";
  };

  misc.enable = true;

  home.packages = with pkgs; [
    headsetcontrol
  ];
}
