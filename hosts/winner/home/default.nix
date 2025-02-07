{pkgs, ...}: {
  imports = [
    ./programs
  ];

  shell.enable = true;
  development.enable = true;
  desktop = {
    enable = true;
    games.enable = true;
    primary-monitor = "DP-2";
  };

  misc.enable = true;

  home.packages = with pkgs; [
    headsetcontrol
    cloudflared
  ];
}
