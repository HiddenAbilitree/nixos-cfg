{config, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
  ];
  laptop.enable = true;
  syncthing.enable = true;
  bootx.plymouth.enable = true;
  distributed-builds.enable = true;
  desktop.enable = true;

  wireguard.client = {
    enable = true;
    PrivateKeyFile = config.sops.secrets.wg-loser-private-key.path;
    address = "10.100.0.2/24";
  };
}
