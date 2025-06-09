{
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "ahci"
        "xhci_pci"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      kernelModules = [];
    };
    kernelModules = ["kvm-amd"];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/cd84749f-3fbf-4d18-9411-82c81d4982ef";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/66CF-EADA";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
  };

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        libvdpau-va-gl
        vaapiIntel
      ];
    };
  };
}
