{
  config,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
  ];

  virtualization.enable = true;

  environment.localBinInPath = true;
  ssh = {
    enable = true;
    x11forwarding = true;
    fail2ban.enable = false;
  };

  bootx = {
    plymouth.enable = true;
    bootloader.enable = true;
  };

  boot.lanzaboote.pkiBundle = lib.mkForce "/var/lib/sbctl";

  syncthing.enable = true;
  distributed-builds.enable = true;
  swap.enable = true;

  # mullvad.enable = true;
  ollama.enable = true;

  hardware.openrazer.enable = true;

  dev.enable = true;

  printing.enable = true;
  networking.nameservers = ["1.1.1.1" "8.8.8.8"];

  wireguard.client = {
    enable = true;
    PrivateKeyFile = config.sops.secrets.wg-winner-private-key.path;
    PresharedKeyFile = config.sops.secrets.wg-winner-psk.path;
    address = "10.100.0.3/24";
  };

  desktop = {
    enable = true;
    games.moe = {
      honkers.enable = true;
      aagl.enable = true;
    };
    services = {
      ratbagd.enable = true;
      keyboard.enable = true;
      sunshine.enable = true;
    };
  };

  services.displayManager.autoLogin = {
    enable = true;
    user = "ezhang";
  };

  programs = {
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    gamescope = {
      enable = true;
    };
    gamemode.enable = true;
    nix-ld.enable = true;
  };

  nix.settings.system-features = [
    "kvm"
    "big-parallel"
    "benchmark"
    "nixos-test"
  ];
}
