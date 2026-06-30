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
    noctalia = {
      enable = true;
      wallpaper = ../../../assets/wallpapers/2880x1920/water.png;
    };
    primary-monitor = "eDP-1";
    games = {
      roblox.enable = false;
      minecraft.enable = true;
    };
  };

  misc.enable = true;
}
