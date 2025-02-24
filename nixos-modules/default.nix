{
  lib,
  config,
  ...
}: {
  imports = [
    ./boot
    ./cloudflared.nix
    ./desktop
    ./distributed-builds.nix
    ./laptop
    ./mullvad
    ./ollama
    ./ssh.nix
    ./swap.nix
    ./syncthing.nix
    ./virtualization
    ./wireguard
  ];

  options = {
    cloudflared.enable = lib.mkEnableOption "Cloudflared Tunnels";

    ssh = {
      enable = lib.mkEnableOption "ssh";
      fail2ban.enable = lib.mkEnableOption "fail2ban";
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

    ollama.enable = lib.mkEnableOption "ollama";

    bootx = {
      secureboot.enable = lib.mkEnableOption "secureboot";
      install.enable = lib.mkEnableOption "install";
      plymouth.enable = lib.mkEnableOption "Plymouth";
    };
  };

  config = {
    services.flatpak.enable = config.home-manager.users.ezhang.misc.flatpak.enable;

    desktop = lib.mkIf config.desktop.enable {
      fonts.enable = lib.mkDefault true;
      hyprland.enable = lib.mkDefault true;
      xserver.enable = lib.mkDefault true;
      services.enable = lib.mkDefault true;
    };

    virtualization = lib.mkIf config.virtualization.enable {
      docker.enable = lib.mkDefault true;
      vm.enable = lib.mkDefault true;
    };

    ssh.fail2ban.enable = lib.mkDefault true;
  };
}
