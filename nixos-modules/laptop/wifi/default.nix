{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.laptop.wifi.enable {
    networking.networkmanager.enable = true;
  };
}
