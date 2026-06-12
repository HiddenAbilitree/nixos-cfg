{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wireguard;
  inherit (cfg) peerName;
  interfaceName = "wg0";
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

  mkWireguardPeer = _name: peer: let
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

  syncConfigMarker = builtins.toFile "wireguard-${peerName}-peers.json" (builtins.toJSON {
    inherit (cfg) listenPort peers;
    inherit peerName;
  });

  renderSyncPeer = _name: peer: let
    renderedPeer = mkWireguardPeer _name peer;
  in ''
    printf '%s\n' ${lib.escapeShellArg "[Peer]"}
    printf '%s\n' ${lib.escapeShellArg "PublicKey = ${renderedPeer.PublicKey}"}
    printf '%s\n' ${lib.escapeShellArg "AllowedIPs = ${lib.concatStringsSep ", " renderedPeer.AllowedIPs}"}
    ${lib.optionalString (renderedPeer ? PresharedKeyFile) ''
      printf '%s' ${lib.escapeShellArg "PresharedKey = "}
      ${pkgs.coreutils}/bin/tr -d '\n' < ${lib.escapeShellArg renderedPeer.PresharedKeyFile}
      printf '\n'
    ''}
    ${lib.optionalString (renderedPeer ? Endpoint) ''
      printf '%s\n' ${lib.escapeShellArg "Endpoint = ${renderedPeer.Endpoint}"}
    ''}
    ${lib.optionalString (renderedPeer ? PersistentKeepalive) ''
      printf '%s\n' ${lib.escapeShellArg "PersistentKeepalive = ${toString renderedPeer.PersistentKeepalive}"}
    ''}
    printf '\n'
  '';

  syncWireguardConfig = pkgs.writeShellScript "wireguard-sync-${peerName}" ''
    set -euo pipefail

    wg_available=false
    for _ in {1..40}; do
      if ${pkgs.wireguard-tools}/bin/wg show ${lib.escapeShellArg interfaceName} >/dev/null 2>&1; then
        wg_available=true
        break
      fi
      ${pkgs.coreutils}/bin/sleep 0.25
    done

    if [ "$wg_available" != true ]; then
      echo "${interfaceName} is not available; systemd-networkd did not create it from declarative config." >&2
      exit 1
    fi

    umask 077
    tmp="$(${pkgs.coreutils}/bin/mktemp -p "''${RUNTIME_DIRECTORY:-/run}" wireguard-${interfaceName}.XXXXXX)"
    trap '${pkgs.coreutils}/bin/rm -f "$tmp"' EXIT

    {
      printf '%s\n' '[Interface]'
      printf '%s' 'PrivateKey = '
      ${pkgs.coreutils}/bin/tr -d '\n' < ${lib.escapeShellArg thisPeer.privateKeyFile}
      printf '\n'
      printf '%s\n' ${lib.escapeShellArg "ListenPort = ${toString cfg.listenPort}"}
      printf '\n'
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList renderSyncPeer reachablePeers)}
    } > "$tmp"

    ${pkgs.wireguard-tools}/bin/wg syncconf ${lib.escapeShellArg interfaceName} "$tmp"
  '';
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
          trustedInterfaces = [interfaceName];
        };
        useNetworkd = true;
      };

      systemd.network = {
        enable = true;
        netdevs."50-${interfaceName}" = {
          netdevConfig = {
            Kind = "wireguard";
            Name = interfaceName;
            MTUBytes = "1440";
          };

          wireguardConfig = {
            PrivateKeyFile = thisPeer.privateKeyFile;
            ListenPort = cfg.listenPort;
          };

          wireguardPeers = lib.mapAttrsToList mkWireguardPeer reachablePeers;
        };

        networks.${interfaceName} = {
          matchConfig.Name = interfaceName;
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

      systemd.services = {
        systemd-networkd = {
          restartIfChanged = false;
        };

        "wireguard-sync-${interfaceName}" = {
          description = "Synchronize WireGuard ${interfaceName} peers without restarting systemd-networkd";
          wantedBy = ["multi-user.target"];
          requires = ["systemd-networkd.service"];
          after = ["systemd-networkd.service"];
          restartTriggers = [syncConfigMarker];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            RuntimeDirectory = "wireguard-sync";
            RuntimeDirectoryMode = "0700";
            ExecStart = syncWireguardConfig;
          };
        };
      };
    })
  ]
