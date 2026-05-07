{
  lib,
  pkgs,
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

  boot = {
    lanzaboote.pkiBundle = lib.mkForce "/var/lib/sbctl";
    kernel.sysctl = {
      "vm.max_map_count" = 1048576;
    };
  };

  syncthing.enable = false;
  distributed-builds.enable = true;
  swap.enable = true;

  # mullvad.enable = true;
  ollama.enable = true;

  hardware.openrazer.enable = true;

  dev.enable = true;

  printing.enable = true;

  networking.nameservers = ["1.1.1.1" "1.0.0.1"];

  services.resolved = {
    enable = true;
    settings.Resolve.FallbackDNS = ["8.8.8.8" "8.8.4.4"];
  };

  wireguard.enable = true;

  desktop = {
    enable = true;
    games = {
      moe = {
        honkers.enable = true;
        aagl.enable = true;
      };
    };
    services = {
      ratbagd.enable = true;
      keyboard.enable = true;
      mouse.enable = true;
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
      package = pkgs.gamescope.overrideAttrs (_: {
        NIX_CFLAGS_COMPILE = ["-fno-fast-math"];
      });
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
