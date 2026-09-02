{
  config,
  lib,
  ...
}:
let
  cfg = config.wireguard.external;
  mesh = config.wireguard;
  interfaceName = "wg0";
  serverIP = lib.head (lib.splitString "/" cfg.serverAddress);
  allowedPorts = {
    from = 25565;
    to = 25585;
  };
  hasServerPeer = builtins.hasAttr mesh.peerName mesh.peers;
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
in
{
  options.wireguard.external = {
    enable = lib.mkEnableOption "the isolated external-client WireGuard network";

    serverAddress = lib.mkOption {
      type = lib.types.str;
      default = "10.102.0.1/24";
      internal = true;
      description = "Server address for the external-client subnet.";
    };

    clients = lib.mkOption {
      type = lib.types.attrsOf clientType;
      default = { };
      description = ''
        External clients authorized to connect to thething. Allocate one unique
        address per client and add its public key here. Client configurations use
        10.102.0.1/32 as AllowedIPs, thething's mesh public key as the server key,
        and thething's public hostname or IP with port 51820 as the endpoint.
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
              iifname "${interfaceName}" ip saddr 10.102.0.0/24 ip daddr ${serverIP} meta l4proto { tcp, udp } th dport ${toString allowedPorts.from}-${toString allowedPorts.to} ct mark set 0x5747
            }

            chain input {
              type filter hook input priority -10; policy accept;
              iifname "${interfaceName}" ip saddr 10.102.0.0/24 ct mark 0x5747 accept
              iifname "${interfaceName}" ip saddr 10.102.0.0/24 drop
            }

            chain forward {
              type filter hook forward priority -10; policy accept;
              iifname "${interfaceName}" ip saddr 10.102.0.0/24 ct mark 0x5747 oifname != "${interfaceName}" accept
              iifname "${interfaceName}" ip saddr 10.102.0.0/24 drop
            }
          '';
        };
      };

      firewall.interfaces.${interfaceName} = {
        allowedTCPPortRanges = [ allowedPorts ];
        allowedUDPPortRanges = [ allowedPorts ];
      };
    };
  };
}
