{config, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
  ];

  laptop.enable = true;

  syncthing.enable = true;

  bootx = {
    plymouth.enable = true;
    bootloader.enable = true;
  };

  distributed-builds.enable = false;

  desktop.enable = true;

  ssh = {
    enable = true;
    fail2ban.enable = false;
  };

  mongodb.enable = true;

  services.displayManager.autoLogin = {
    enable = true;
    user = "ezhang";
  };

  programs = {
    steam.enable = true;
    gamemode.enable = true;
  };

  # mullvad.enable = true;

  wireguard.client = {
    enable = true;
    PrivateKeyFile = config.sops.secrets.wg-loser-private-key.path;
    PresharedKeyFile = config.sops.secrets.wg-loser-psk.path;
    address = "10.100.0.2/24";
  };
}
