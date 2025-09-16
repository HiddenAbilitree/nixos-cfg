{
  lib,
  root,
  osConfig,
  ...
}: {
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
    };
  };

  programs.spicetify.enable = lib.mkForce false;

  misc.enable = true;
}
