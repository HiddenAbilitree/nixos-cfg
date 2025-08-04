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
      roblox.enable = true;
      minecraft.enable = true;
      moe = {
        honkers.enable = true;
        aagl.enable = true;
      };
    };
  };

  misc.enable = true;
}
