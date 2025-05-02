{
  config,
  lib,
  ...
}:
lib.mkIf config.wireguard.client.enable {
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
          inherit (config.wireguard.client) PrivateKeyFile;
          ListenPort = config.wireguard.listenPort;
        };
        wireguardPeers = [
          {
            inherit (config.wireguard.client) PresharedKeyFile;
            PublicKey = "lHHJlzI/DCtaptEw75Uz121FcPeiAPAq91l6PZET0xc="; # server public key
            AllowedIPs = ["10.100.0.1" "10.100.0.2" "10.100.0.3"];
            Endpoint = "${config.ip}:${toString config.wireguard.listenPort}";
            PersistentKeepalive = 25;
          }
        ];
      };
    };
    networks.wg0 = {
      matchConfig.Name = "wg0";
      # IP addresses the client interface will have
      address = [config.wireguard.client.address];
      DHCP = "no";
      networkConfig = {
        IPv6AcceptRA = false;
      };
    };
  };
}
