{
  config,
  lib,
  ...
}:
lib.mkIf config.desktop.games.roblox.enable {
  services.flatpak.packages = [
    "org.vinegarhq.Sober"
  ];
  misc.flatpak.enable = lib.mkDefault true;
}
