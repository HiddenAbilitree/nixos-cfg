{
  imports = [
    ./programs
  ];

  shell.enable = true;
  development.enable = true;
  desktop = {
    enable = true;
    primary-monitor = "eDP-1";
    games.roblox.enable = true;
  };
  misc.enable = true;
}
