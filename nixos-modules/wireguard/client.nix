{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.wireguard.client.enable {
    systemd.network = {
      enable = true;
      netdevs = {
        "10-wg0" = {
          netdevConfig = {
            Kind = "wireguard";
            Name = "wg0";
            MTUBytes = "1440";
          };
          wireguardConfig = {
            PrivateKeyFile = config.wireguard.client.PrivateKeyFile;
            ListenPort = 9918;
          };
          wireguardPeers = [
            {
              PublicKey = "L4msD0mEG2ctKDtaMJW2y3cs1fT2LBRVV7iVlWZ2nZc="; # server public key
              AllowedIPs = ["10.100.0.1/32"];
              Endpoint = "${config.ip}:${toString config.wireguard.listenPort}";
              PersistentKeepalive = 25;
            }
          ];
        };
      };
      networks.wg0 = {
        matchConfig.Name = "wg0";
        # IP addresses the client interface will have
        address = [
          config.wireguard.client.address
        ];
        DHCP = "no";
        networkConfig = {
          IPv6AcceptRA = false;
        };
      };
    };
  };
}