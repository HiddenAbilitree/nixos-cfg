{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.wireguard.external;
  mesh = config.wireguard;
  interfaceName = "wg-external";
  serverAddress = "10.102.0.1/24";
  serverIP = "10.102.0.1";
  listenPort = 51821;
  allowedPorts = {
    from = 25565;
    to = 25585;
  };
  hasServerPeer = builtins.hasAttr mesh.peerName mesh.peers;
  serverPeer = mesh.peers.${mesh.peerName} or null;
  clientAddresses = map (client: client.address) (builtins.attrValues cfg.clients);
  clientPublicKeys = map (client: client.publicKey) (builtins.attrValues cfg.clients);

  clientType = lib.types.submodule {
    options = {
      publicKey = lib.mkOption {
        type = lib.types.strMatching "[A-Za-z0-9+/]{43}=";
        description = "WireGuard public key for this external client.";
      };

      address = lib.mkOption {
        type = lib.types.strMatching "10\\.102\\.0\\.([2-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-4])";
        description = "Unique VPN address assigned to this client.";
        example = "10.102.0.2";
      };
    };
  };

  mkWireguardPeer = client: {
    PublicKey = client.publicKey;
    AllowedIPs = [ "${client.address}/32" ];
  };

  mkRoute = client: {
    Destination = "${client.address}/32";
    Scope = "link";
  };

  syncConfigMarker = builtins.toFile "wireguard-external-peers.json" (
    builtins.toJSON {
      inherit listenPort;
      clients = cfg.clients;
    }
  );

  renderSyncPeer = _: client: ''
    printf '%s\n' '[Peer]'
    printf '%s\n' ${lib.escapeShellArg "PublicKey = ${client.publicKey}"}
    printf '%s\n' ${lib.escapeShellArg "AllowedIPs = ${client.address}/32"}
    printf '\n'
  '';

  syncWireguardConfig = pkgs.writeShellScript "wireguard-sync-external" ''
    set -euo pipefail
    ${pkgs.systemd}/bin/busctl call org.freedesktop.network1 /org/freedesktop/network1 org.freedesktop.network1.Manager Reload

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
      ${pkgs.coreutils}/bin/tr -d '\n' < ${lib.escapeShellArg serverPeer.privateKeyFile}
      printf '\n'
      printf '%s\n' ${lib.escapeShellArg "ListenPort = ${toString listenPort}"}
      printf '\n'
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList renderSyncPeer cfg.clients)}
    } > "$tmp"

    ${pkgs.wireguard-tools}/bin/wg syncconf ${lib.escapeShellArg interfaceName} "$tmp"
  '';
in
{
  options.wireguard.external = {
    enable = lib.mkEnableOption "the isolated external-client WireGuard network";

    clients = lib.mkOption {
      type = lib.types.attrsOf clientType;
      default = { };
      description = ''
        External clients authorized to connect to thething. Allocate one unique
        address per client and add its public key here. Client configurations use
        10.102.0.1/32 as AllowedIPs, thething's mesh public key as the server key,
        and thething's public hostname or IP with port 51821 as the endpoint.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = mesh.enable && hasServerPeer;
        message = "wireguard.external requires this host to be an enabled wireguard mesh peer.";
      }
      {
        assertion = lib.length clientAddresses == lib.length (lib.unique clientAddresses);
        message = "wireguard.external client addresses must be unique.";
      }
      {
        assertion = lib.length clientPublicKeys == lib.length (lib.unique clientPublicKeys);
        message = "wireguard.external client public keys must be unique.";
      }
    ];

    networking = {
      nftables = {
        enable = true;
        tables.wireguard-external-isolation = {
          family = "inet";
          content = ''
            chain classify {
              type filter hook prerouting priority -110; policy accept;
              iifname "${interfaceName}" ip daddr ${serverIP} meta l4proto { tcp, udp } th dport ${toString allowedPorts.from}-${toString allowedPorts.to} ct mark set 0x5747
            }

            chain input {
              type filter hook input priority -10; policy accept;
              iifname "${interfaceName}" ct mark 0x5747 accept
              iifname "${interfaceName}" drop
            }

            chain forward {
              type filter hook forward priority -10; policy accept;
              iifname "${interfaceName}" ct mark 0x5747 oifname != "${interfaceName}" accept
              iifname "${interfaceName}" drop
            }
          '';
        };
      };

      firewall = {
        allowedUDPPorts = [ listenPort ];
        interfaces.${interfaceName} = {
          allowedTCPPortRanges = [ allowedPorts ];
          allowedUDPPortRanges = [ allowedPorts ];
        };
      };
    };

    systemd.network = {
      netdevs."50-${interfaceName}" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = interfaceName;
          MTUBytes = "1440";
        };

        wireguardConfig = {
          PrivateKeyFile = serverPeer.privateKeyFile;
          ListenPort = listenPort;
        };

        wireguardPeers = map mkWireguardPeer (builtins.attrValues cfg.clients);
      };

      networks.${interfaceName} = {
        matchConfig.Name = interfaceName;
        addresses = [
          { Address = serverAddress; }
        ];
        routes = map mkRoute (builtins.attrValues cfg.clients);
        networkConfig = {
          DHCP = "no";
          IPv6AcceptRA = false;
        };
      };
    };

    systemd.services."wireguard-sync-${interfaceName}" = {
      description = "Synchronize WireGuard ${interfaceName} peers without restarting systemd-networkd";
      wantedBy = [ "multi-user.target" ];
      requires = [ "systemd-networkd.service" ];
      after = [ "systemd-networkd.service" ];
      restartTriggers = [ syncConfigMarker ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        RuntimeDirectory = "wireguard-sync-external";
        RuntimeDirectoryMode = "0700";
        ExecStart = syncWireguardConfig;
      };
    };
  };
}
