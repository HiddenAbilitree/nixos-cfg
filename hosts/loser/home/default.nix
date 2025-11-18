{
  imports = [
    ./programs
  ];

  shell = {
    enable = true;
    zellij.autostart = false;
  };

  desktop = {
    enable = true;
    primary-monitor = "eDP-1";
    games = {
      roblox.enable = false;
      minecraft.enable = false;
    };
  };

  misc.enable = true;
}
