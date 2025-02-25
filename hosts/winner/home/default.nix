{pkgs, ...}: {
  imports = [
    ./programs
  ];

  shell.enable = true;
  development.enable = true;
  desktop = {
    hyprland = {
      hypridle.enable = false;
      hyprlock.enable = false;
    };
    enable = true;
    games = {
      enable = true;
      roblox.enable = false;
    };
    primary-monitor = "DP-2";
  };

  misc.enable = true;

  home.packages = with pkgs; [
    headsetcontrol
    cloudflared
  ];
}
