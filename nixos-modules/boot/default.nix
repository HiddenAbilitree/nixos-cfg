{
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./plymouth.nix
    ./secureboot.nix
  ];

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

  options.bootx.bootloader.enable = lib.mkEnableOption "bootloader";
}
