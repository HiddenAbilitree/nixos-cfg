{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.laptop.wifi.enable {
    networking.networkmanager.enable = true;
    # environment.systemPackages = [pkgs.networkmanagerapplet];
  };
}
