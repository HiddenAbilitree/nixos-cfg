{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./plymouth.nix
    ./secureboot.nix
  ];

  options.bootx = {
    bootloader.enable = lib.mkEnableOption "bootloader";
    install.enable = lib.mkEnableOption "install";
  };

  config.boot = lib.mkIf config.bootx.bootloader.enable {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = lib.mkDefault true;
        consoleMode = "max";
      };
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };
}
