{
  config,
  lib,
  pkgs,
  ...
}:
{
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
    kernelPackages = pkgs.linuxPackages_latest.extend (
      _: prev: {
        v4l2loopback = prev.v4l2loopback.overrideAttrs (old: {
          installFlags = (old.installFlags or [ ]) ++ [ "DEPMOD=true" ];
        });
        framework-laptop-kmod = prev.framework-laptop-kmod.overrideAttrs (old: {
          makeFlags = old.makeFlags ++ [
            "INSTALL_MOD_PATH=${placeholder "out"}"
            "INSTALL_MOD_DIR=extra"
            "DEPMOD=true"
          ];
          installPhase = null;
          installTargets = [ "modules_install" ];
        });
      }
    );
  };
}
