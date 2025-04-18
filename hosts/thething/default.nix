{
  imports = [./disk-config.nix ./hardware-configuration.nix];

  ssh = {
    enable = true;
    fail2ban.enable = false;
  };

  boot.kernel.sysctl = {
    "net.core.rmem_max" = 7500000;
    "net.core.wmem_max" = 7500000;
  };

  syncthing.enable = true;

  virtualization.docker.enable = true;

  wireguard.server.enable = true;

  nix.settings.system-features = [
    "kvm"
    "big-parallel"
    "benchmark"
    "nixos-test"
  ];

  thething.enable = false;
}
