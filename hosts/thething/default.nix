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

  virtualization.docker.enable = true;

  wireguard.server.enable = true;

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM0RksE+h4vQe1ig2wLUYcc3uxjxC43Zzq7Ki3TNNxVq eric@ericzhang.dev"
  ];

  nix = {
    settings = {
      system-features = [
        "kvm"
        "big-parallel"
        "benchmark"
        "nixos-test"
      ];
    };
  };
}
