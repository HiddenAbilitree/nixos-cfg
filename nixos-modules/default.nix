{
  config,
  ...
}: {
  imports = [
    ./boot
    ./certs
    ./cloudflared.nix
    ./desktop
    ./distributed-builds.nix
    ./dns
    ./laptop
    ./mongodb.nix
    ./mullvad
    ./ollama
    ./printing.nix
    ./ssh.nix
    ./swap.nix
    ./syncthing.nix
    ./virtualization
    ./wireguard
  ];

  config.services.flatpak.enable = config.home-manager.users.ezhang.misc.flatpak.enable;
}
