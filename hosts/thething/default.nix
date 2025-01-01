{
  imports = [./disk-config.nix ./hardware-configuration.nix];

  ssh = {
    enable = true;
    fail2ban.enable = false;
  };

  wireguard.server.enable = true;

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM0RksE+h4vQe1ig2wLUYcc3uxjxC43Zzq7Ki3TNNxVq eric@ericzhang.dev"
  ];
}
