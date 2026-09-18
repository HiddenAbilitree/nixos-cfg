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
  nix.settings.trusted-substituters = [
    "https://noctalia.cachix.org"
    "https://ezkea.cachix.org"
    "https://hyprland.cachix.org"
    "https://hiddenability.cachix.org"
    "https://lanzaboote.cachix.org"
    "https://nix-community.cachix.org"
    "https://prismlauncher.cachix.org"
    "https://vicinae.cachix.org"
    "https://cache.numtide.com"
    "https://cache.thalheim.io"
    "https://cache.kunet.dev/eric-cache"
  ];
  nix.settings.trusted-public-keys = [
    "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
    "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    "hiddenability.cachix.org-1:XoQgwtf8NLgOSELrDs0vOwB5WofUaYqVCJdn1ANf6n0="
    "lanzaboote.cachix.org-1:Nt9//zGmqkg1k5iu+B3bkj3OmHKjSw9pvf3faffLLNk="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "prismlauncher.cachix.org-1:9/n/FGyABA2jLUVfY+DEp4hKds/rwO+SCOtbOkDzd+c="
    "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
    "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    "cache.thalheim.io-1:R7msbosLEZKrxk/lKxf9BTjOOH7Ax3H0Qj0/6wiHOgc="
    "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
  ];

  nextcloud.enable = false;
  pterodactyl.enable = false;
  syncthing.enable = true;
  ollama.enable = false;

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
      enable = false;
      user = "ezhang";
      group = "users";
      listenAddress = "10.100.0.1";
      port = 6767;
      hostnames = [ "thething" ];
      relay = {
        enable = false;
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
