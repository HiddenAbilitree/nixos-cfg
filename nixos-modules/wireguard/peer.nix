{
  config,
  lib,
  ...
}: let
  cfg = config.wireguard;
  thisPeer = cfg.peers.${cfg.peer};

  otherPeers = lib.filterAttrs (name: _: name != cfg.peer) cfg.peers;

  extractIP = addr: lib.head (lib.splitString "/" addr);

  relayIP =
    (lib.findFirst (peer: peer.isRelay) null (lib.attrValues cfg.peers)).address
    or null;
  dnsServer =
    if relayIP != null
    then extractIP relayIP
    else null;

  allAllowedIPs = lib.flatten (lib.mapAttrsToList (_: peer: peer.allowedIPs) otherPeers);

  mkRoute = ip: {
    Destination = ip;
    Scope = "link";
  };

  getPskSecret = name: peer:
    if thisPeer.isRelay
    then peer.presharedKeySecret
    else if peer.isRelay
    then thisPeer.presharedKeySecret
    else peer.presharedKeySecret;

  mkWireguardPeer = name: peer: let
    pskSecret = getPskSecret name peer;
  in
    {
      PublicKey = peer.publicKey;
      AllowedIPs = peer.allowedIPs;
    }
    // lib.optionalAttrs (pskSecret != null) {
      PresharedKeyFile = config.sops.secrets.${pskSecret}.path;
    }
    // lib.optionalAttrs (peer.endpoint != null) {
      Endpoint = "${peer.endpoint}:${toString cfg.listenPort}";
      PersistentKeepalive = 25;
    };
in
  lib.mkIf (cfg.peer != null) {
    networking = {
      firewall = {
        allowedUDPPorts = [cfg.listenPort];
        trustedInterfaces = ["wg0"];
      };
      useNetworkd = true;
    };

    systemd.network = {
      enable = true;
      netdevs."50-wg0" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg0";
          MTUBytes = "1440";
        };

        wireguardConfig = {
          PrivateKeyFile = thisPeer.privateKeyFile;
          ListenPort = cfg.listenPort;
        };

        wireguardPeers = lib.mapAttrsToList mkWireguardPeer otherPeers;
      };

      networks.wg0 = {
        matchConfig.Name = "wg0";
        address = [thisPeer.address];
        DHCP = "no";
        routes = map mkRoute allAllowedIPs;
        networkConfig =
          {
            IPv6AcceptRA = false;
          }
          // lib.optionalAttrs thisPeer.isRelay {
            IPMasquerade = "ipv4";
            IPv4Forwarding = true;
          }
          // lib.optionalAttrs (!thisPeer.isRelay && dnsServer != null) {
            DNS = dnsServer;
            Domains = "~wg";
          };
      };
    };
  }
