{
  config,
  lib,
  ...
}: {
  imports = [./disk-config.nix ./hardware-configuration.nix];

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
    enableNvidia = lib.mkForce true;
  };

  hardware.nvidia-container-toolkit = {inherit (config.virtualisation.docker) enable;};

  bootx.bootloader.enable = true;

  syncthing.enable = true;
  ollama.enable = true;

  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia.open = true;
  hardware.graphics.enable32Bit = true;

  wireguard.server.enable = true;

  nix.settings.system-features = [
    "kvm"
    "big-parallel"
    "benchmark"
    "nixos-test"
  ];

  thething.enable = false;
}
