{
  lib,
  config,
  ...
}: {
  imports = [
    ./boot
    ./desktop
    ./distributed-builds.nix
    ./laptop
    ./server
    ./swap.nix
    ./syncthing.nix
    ./virtualization
    ./wireguard
  ];

  options = {
    server = {
      cloudflared.enable = lib.mkEnableOption "Cloudflared Tunnels";
      ssh = {
        enable = lib.mkEnableOption "ssh";
        fail2ban.enable = lib.mkEnableOption "fail2ban";
      };
    };

    syncthing.enable = lib.mkEnableOption "Syncthing";

    swap.enable = lib.mkEnableOption "swap";

    distributed-builds.enable = lib.mkEnableOption "distributed builds";

    desktop = {
      enable = lib.mkEnableOption "desktop";
      hyprland.enable = lib.mkEnableOption "Hyprland";
      xserver.enable = lib.mkEnableOption "xserver";
      fonts.enable = lib.mkEnableOption "fonts";
    };

    virtualization = {
      enable = lib.mkEnableOption "virtualization";
      docker.enable = lib.mkEnableOption "docker";
      vm.enable = lib.mkEnableOption "vm";
    };

    bootx = {
      secureboot.enable = lib.mkEnableOption "secureboot";
      install.enable = lib.mkEnableOption "install";
      plymouth.enable = lib.mkEnableOption "Plymouth";
    };
  };

  config = {
    desktop = lib.mkIf config.desktop.enable {
      fonts.enable = lib.mkDefault true;
      hyprland.enable = lib.mkDefault true;
      xserver.enable = lib.mkDefault true;
    };

    virtualization = lib.mkIf config.virtualization.enable {
      docker.enable = lib.mkDefault true;
      vm.enable = lib.mkDefault true;
    };

    server.ssh.fail2ban.enable = lib.mkDefault true;
  };
}
