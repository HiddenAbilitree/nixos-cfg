{
  lib,
  pkgs,
  config,
  ...
}: let
  zfsCompatibleKernelPackages =
    lib.filterAttrs (
      name: kernelPackages:
        (builtins.match "linux_[0-9]+_[0-9]+" name)
        != null
        && (builtins.tryEval kernelPackages).success
        && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
    )
    pkgs.linuxKernel.packages;
  latestKernelPackage = lib.last (
    lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );
in {
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

  # environment.systemPackages = [pkgs.zfs];

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

  # Note this might jump back and forth as kernels are added or removed.
  boot.kernelPackages = lib.mkForce latestKernelPackage;

  wireguard.peer = "thething";

  internal-dns = {
    enable = true;
    extraHosts = {
      "observability.wg" = "10.100.0.1";
      "git.wg" = "10.100.0.1";
      "panel.wg" = "10.100.0.1";
      "wings.wg" = "10.100.0.1";
      "cloud.wg" = "10.100.0.1";
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
