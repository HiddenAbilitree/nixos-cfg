{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types;

  mkHostAllowedIP = address: let
    ip = lib.head (lib.splitString "/" address);
    prefixLength =
      if lib.hasInfix ":" ip
      then "128"
      else "32";
  in "${ip}/${prefixLength}";

  peerType = types.submodule ({config, ...}: {
    options = {
      publicKey = mkOption {
        type = types.str;
        description = "WireGuard public key for this peer.";
      };

      privateKeyFile = mkOption {
        type = types.str;
        description = "Path to the runtime file containing this peer's private key.";
      };

      address = mkOption {
        type = types.str;
        description = "Interface address assigned to this peer, including prefix length.";
        example = "10.100.0.1/24";
      };

      allowedIPs = mkOption {
        type = types.listOf types.str;
        default = [(mkHostAllowedIP config.address)];
        defaultText = lib.literalExpression ''[ "<host address>/32" ]'';
        description = ''
          WireGuard AllowedIPs advertised for this peer. Defaults to the host
          route derived from `address`.
        '';
        example = ["10.100.0.1/32"];
      };

      endpoint = mkOption {
        type = types.nullOr types.str;
        description = "Public endpoint host/IP. The mesh listenPort is appended when rendering the peer.";
        default = null;
      };

      isRelay = mkOption {
        type = types.bool;
        description = "Whether this peer relays otherwise unreachable mesh peers.";
        default = false;
      };

      presharedKeyFile = mkOption {
        type = types.nullOr types.str;
        description = "Path to the runtime file containing the preshared key for links to this peer.";
        default = null;
      };
    };
  });
in {
  imports = [
    ./peer.nix
  ];

  options.wireguard = {
    enable = lib.mkEnableOption "the private WireGuard mesh";

    listenPort = lib.mkOption {
      type = lib.types.port;
      description = "Port to listen on for WireGuard.";
      default = 51820;
    };

    peerName = mkOption {
      type = types.str;
      description = "Name of this host in the WireGuard peers attrset.";
      default = config.networking.hostName;
      defaultText = lib.literalExpression "config.networking.hostName";
    };

    peers = mkOption {
      type = types.attrsOf peerType;
      description = "Attrset of all WireGuard peers in the mesh";
      default = {};
    };
  };

  config.wireguard.peers = {
    thething = {
      publicKey = "lHHJlzI/DCtaptEw75Uz121FcPeiAPAq91l6PZET0xc=";
      privateKeyFile = config.sops.secrets.wg-thething-private-key.path;
      address = "10.100.0.1/24";
      endpoint = config.ip;
      isRelay = true;
    };
    loser = {
      publicKey = "nL4DkJLnD/EwRGg+DHAsjDE2rg/hEibFb88b6Y7szBc=";
      privateKeyFile = config.sops.secrets.wg-loser-private-key.path;
      address = "10.100.0.2/24";
      presharedKeyFile = config.sops.secrets.wg-loser-psk.path;
    };
    winner = {
      publicKey = "qPEAvFY7/rwheiLX1Xn3EI1pnDmbF4VslClPmkDn10o=";
      privateKeyFile = config.sops.secrets.wg-winner-private-key.path;
      address = "10.100.0.3/24";
      presharedKeyFile = config.sops.secrets.wg-winner-psk.path;
    };
    vps = {
      publicKey = "uuRHwpFxt1Rfx7evsx7Q9ElnFuVA6ToAqHKigK+eIxk=";
      privateKeyFile = config.sops.secrets.wg-vps-private-key.path;
      address = "10.101.0.1/24";
      endpoint = "15.204.232.112";
      presharedKeyFile = config.sops.secrets.wg-vps-psk.path;
    };
    ionos = {
      publicKey = "TfiQ1sab9qT+Qi0Jhg2FtRrNtugN3V9hWaO+sm2CUXw=";
      privateKeyFile = config.sops.secrets.wg-ionos-private-key.path;
      address = "10.101.0.2/24";
      endpoint = "74.208.200.220";
      isRelay = true;
      presharedKeyFile = config.sops.secrets.wg-ionos-psk.path;
    };
  };
}
