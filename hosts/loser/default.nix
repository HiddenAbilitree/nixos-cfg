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

  ssh = {
    enable = true;
    fail2ban.enable = false;
  };

  services.displayManager.autoLogin = {
    enable = true;
    user = "ezhang";
  };

  wireguard.client = {
    enable = true;
    PrivateKeyFile = config.sops.secrets.wg-loser-private-key.path;
    PresharedKeyFile = config.sops.secrets.wg-loser-psk.path;
    address = "10.100.0.2/24";
  };
}
