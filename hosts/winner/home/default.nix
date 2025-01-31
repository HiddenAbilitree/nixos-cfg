{pkgs, ...}: {
  imports = [
    ./programs
  ];

  shell.enable = true;
  development.enable = true;
  desktop = {
    enable = true;
    games.enable = true;
  };

  misc.enable = true;

  home.packages = with pkgs; [
    headsetcontrol
    cloudflared
  ];
}
