{config, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../nixos-modules
  ];

  virtualization.enable = true;

  server = {
    cloudflared.enable = true;
    ssh.enable = true;
  };

  bootx.plymouth.enable = true;

  syncthing.enable = true;
  distributed-builds.enable = true;
  swap.enable = true;

  wireguard.client = {
    enable = true;
    PrivateKeyFile = config.sops.secrets.wg-winner-private-key.path;
    address = "10.100.0.3/24";
  };

  desktop.enable = true;

  services.displayManager.autoLogin = {
    enable = true;
    user = "ezhang";
  };

  programs.steam.enable = true;

  boot.kernel.sysctl = {
    "net.core.rmem_max" = 7500000;
    "net.core.wmem_max" = 7500000;
  };

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
