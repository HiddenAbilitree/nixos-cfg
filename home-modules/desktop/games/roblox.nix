{
  config,
  lib,
  ...
}:
lib.mkIf config.desktop.games.roblox.enable {
  services.flatpak.packages = [
    {
      flatpakref = "https://sober.vinegarhq.org/sober.flatpakref";
      sha256 = "54546f6e843b219c180d0bc47168a63ae9e8eef223fb9133b4ebf1087bf048de";
    }
  ];
  misc.flatpak.enable = lib.mkDefault true;
}
