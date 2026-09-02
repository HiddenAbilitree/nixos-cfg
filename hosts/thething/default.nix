{
  config,
  lib,
  pkgs,
  ...
}:
let
  zfsCompatibleKernelPackages = lib.filterAttrs (
    name: kernelPackages:
    (builtins.match "linux_[0-9]+_[0-9]+" name) != null
    && (builtins.tryEval kernelPackages).success
    && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
  ) pkgs.linuxKernel.packages;
  latestKernelPackage = lib.last (
    lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );
in
{
  imports = [
    ./disk-config.nix
    ./hardware-configuration.nix
    ./zfs.nix
  ];

  ssh = {
    enable = true;
    fail2ban.enable = false;
  };

  boot.kernel.sysctl = {
    "net.core.rmem_max" = 7500000;
    "net.core.wmem_max" = 7500000;
  };

  networking.firewall.interfaces.enp6s0.allowedTCPPorts = [ config.observability.grafanaPort ];

  virtualisation.docker = {
    enable = lib.mkForce true;
    daemon.settings.live-restore = false;
  };

  programs.nix-ld.enable = true;

  bootx.bootloader.enable = true;

  runners.enable = true;

  nextcloud.enable = false;
  pterodactyl.enable = false;
  syncthing.enable = true;
  ollama.enable = true;

  gpu.vendor = "nvidia";
  observability = {
    enable = true;
    sops.enable = true;
    grafanaListenAddress = "0.0.0.0";
  };
  services = {
    atuin = {
      enable = true;
      host = "0.0.0.0";
      port = 18888;
      openRegistration = true;
    };

    fwupd.enable = lib.mkForce false;

    dokploy = {
      environment = {
        TZ = "America/New_York";
      };
      enable = true;

      image = "dokploy/dokploy:latest";
      database.passwordFile = config.sops.secrets.dokploy-db-pwd.path;
      encryption.keyFile = config.sops.secrets.dokploy-encryption-key.path;
    };

    paseo = {
      enable = true;
      user = "ezhang";
      group = "users";
      listenAddress = "10.100.0.1";
      port = 6767;
      hostnames = [ "thething" ];
      relay = {
        enable = true;
        mode = "hosted";
      };
      environment.PASEO_RELAY_ENABLED = "true";
    };
  };

  boot.kernelPackages = lib.mkForce latestKernelPackage;

  wireguard = {
    enable = true;
    external = {
      enable = true;
      clients = {
        "2" = {
          publicKey = "ic3kjVJnuahXRzDGXHrP2VdivTdCCPuaYDE0wQQPakU=";
          address = "10.102.0.2";
        };
      };
    };
  };

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
