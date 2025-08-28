{
  config,
  lib,
  ...
}:
lib.mkIf config.wireguard.server.enable {
  networking = {
    firewall = {
      allowedUDPPorts = [ config.wireguard.listenPort ];
      trustedInterfaces = [ "wg0" ];
    };
    useNetworkd = true;
  };

  systemd = {
    services.systemd-networkd.serviceConfig.LoadCredential = [
      "network.wireguard.private.50-wg0:${config.sops.secrets.wg-server-private-key.path}"
    ];
    network = {
      enable = true;
      netdevs."50-wg0" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg0";
          MTUBytes = "1440";
        };

        wireguardConfig = {
          PrivateKeyFile = config.sops.secrets.wg-server-private-key.path;
          ListenPort = config.wireguard.listenPort;
        };

        wireguardPeers = [
          {
            PresharedKeyFile = config.sops.secrets.wg-loser-psk.path;
            PublicKey = "nL4DkJLnD/EwRGg+DHAsjDE2rg/hEibFb88b6Y7szBc=";
            AllowedIPs = [ "10.100.0.2" ];
            PersistentKeepalive = 25;
          }
          {
            PresharedKeyFile = config.sops.secrets.wg-winner-psk.path;
            PublicKey = "qPEAvFY7/rwheiLX1Xn3EI1pnDmbF4VslClPmkDn10o=";
            AllowedIPs = [ "10.100.0.3" ];
            PersistentKeepalive = 25;
          }
        ];
      };

      networks.wg0 = {
        matchConfig.Name = "wg0";
        address = [ "10.100.0.1/24" ];
        networkConfig = {
          IPMasquerade = "ipv4";
          IPv4Forwarding = true;
        };
      };
    };
  };
}
