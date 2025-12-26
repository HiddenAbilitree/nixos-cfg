{...}: {
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
  ];
  virtualization.enable = true;

  laptop.enable = true;

  syncthing.enable = true;

  bootx = {
    plymouth.enable = true;
    bootloader.enable = true;
  };

  distributed-builds.enable = true;

  desktop.enable = true;

  ssh = {
    enable = true;
    fail2ban.enable = false;
  };

  mongodb.enable = false;

  services.displayManager.autoLogin = {
    enable = true;
    user = "ezhang";
  };

  programs = {
    steam.enable = false;
    gamemode.enable = false;
    nix-ld.enable = true;
  };

  # mullvad.enable = true;

  wireguard.peer = "loser";
}
