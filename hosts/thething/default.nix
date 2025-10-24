{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./disk-config.nix
    ./hardware-configuration.nix
  ];

  ssh = {
    enable = true;
    fail2ban.enable = false;
  };

  boot.kernel.sysctl = {
    "net.core.rmem_max" = 7500000;
    "net.core.wmem_max" = 7500000;
  };

  virtualisation.docker = {
    enable = lib.mkForce true;
  };

  environment.systemPackages = [pkgs.zfs];

  bootx.bootloader.enable = true;

  nextcloud.enable = false;
  pterodactyl.enable = false;
  syncthing.enable = true;
  ollama.enable = true;
  services.xserver.videoDrivers = ["nvidia"];

  hardware = {
    nvidia.open = true;
    nvidia-container-toolkit.enable = true;
    graphics.enable32Bit = true;
  };

  wireguard.server.enable = true;

  nix.settings.system-features = [
    "kvm"
    "big-parallel"
    "benchmark"
    "nixos-test"
  ];

  thething = {
    enable = false;
    networking.enable = true;
  };
}
