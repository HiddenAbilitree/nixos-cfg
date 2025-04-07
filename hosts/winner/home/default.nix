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
    enable = true;
    games = {
      enable = true;
      honkers.enable = false;
    };
    primary-monitor = "DP-2";
  };

  misc.enable = true;

  home.packages = with pkgs; [
    headsetcontrol
  ];
}
