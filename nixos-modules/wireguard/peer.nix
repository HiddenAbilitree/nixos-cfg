{
  config,
  lib,
  ...
}: let
  cfg = config.wireguard;
  inherit (cfg) peerName;
  hasPeer = builtins.hasAttr peerName cfg.peers;
  thisPeer = cfg.peers.${peerName} or null;

  otherPeers = lib.filterAttrs (name: _: name != peerName) cfg.peers;

  allAllowedIPs = lib.flatten (lib.mapAttrsToList (_: peer: peer.allowedIPs) otherPeers);

  mkRoute = ip: {
    Destination = ip;
    Scope = "link";
  };

  reachablePeers =
    if thisPeer.isRelay
    then otherPeers
    else lib.filterAttrs (_: peer: peer.endpoint != null) otherPeers;

  relayedIPs =
    if thisPeer.isRelay
    then []
    else
      lib.flatten (lib.mapAttrsToList (_: peer: peer.allowedIPs)
        (lib.filterAttrs (_: peer: peer.endpoint == null) otherPeers));

  getPskFile = peer:
    if thisPeer.isRelay
    then peer.presharedKeyFile
    else if peer.isRelay
    then thisPeer.presharedKeyFile
    else peer.presharedKeyFile;

  mkWireguardPeer = name: peer: let
    pskFile = getPskFile peer;
    effectiveAllowedIPs =
      if peer.isRelay && !thisPeer.isRelay
      then peer.allowedIPs ++ relayedIPs
      else peer.allowedIPs;
  in
    {
      PublicKey = peer.publicKey;
      AllowedIPs = effectiveAllowedIPs;
    }
    // lib.optionalAttrs (pskFile != null) {
      PresharedKeyFile = pskFile;
    }
    // lib.optionalAttrs (peer.endpoint != null) {
      Endpoint = "${peer.endpoint}:${toString cfg.listenPort}";
      PersistentKeepalive = 25;
    };
in
  lib.mkMerge [
    {
      assertions = lib.optional cfg.enable {
        assertion = hasPeer;
        message = ''
          wireguard.peerName (${peerName}) must refer to one of config.wireguard.peers:
          ${lib.concatStringsSep ", " (lib.attrNames cfg.peers)}
        '';
      };
    }
    (lib.mkIf (cfg.enable && hasPeer) {
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

          wireguardPeers = lib.mapAttrsToList mkWireguardPeer reachablePeers;
        };

        networks.wg0 = {
          matchConfig.Name = "wg0";
          addresses = [
            {Address = thisPeer.address;}
          ];
          routes = map mkRoute allAllowedIPs;
          networkConfig =
            {
              DHCP = "no";
              IPv6AcceptRA = false;
            }
            // lib.optionalAttrs thisPeer.isRelay {
              IPMasquerade = "ipv4";
              IPv4Forwarding = true;
            };
        };
      };
    })
  ]
