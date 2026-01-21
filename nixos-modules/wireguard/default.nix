{
  lib,
  config,
  ...
}: {
  imports = [
    ./peer.nix
  ];

  options.wireguard = {
    listenPort = lib.mkOption {
      type = lib.types.int;
      description = "Port to listen on for wireguard";
      default = 51820;
    };

    peer = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = "Name of this host in the peers attrset";
      default = null;
    };

    peers = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          publicKey = lib.mkOption {
            type = lib.types.str;
            description = "wg public key";
          };

          privateKeyFile = lib.mkOption {
            type = lib.types.str;
            description = "wg private key file";
          };

          address = lib.mkOption {
            type = lib.types.str;
            description = "wg ip";
          };

          allowedIPs = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            description = "";
          };

          endpoint = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            description = "public endpoint";
            default = null;
          };

          isRelay = lib.mkOption {
            type = lib.types.bool;
            description = "";
            default = false;
          };

          presharedKeySecret = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            description = "sops secret name containing psk";
            default = null;
          };
        };
      });
      description = "Attrset of all WireGuard peers in the mesh";
      default = {};
    };
  };

  config.wireguard.peers = {
    thething = {
      publicKey = "lHHJlzI/DCtaptEw75Uz121FcPeiAPAq91l6PZET0xc=";
      privateKeyFile = config.sops.secrets.wg-thething-private-key.path;
      address = "10.100.0.1/24";
      allowedIPs = ["10.100.0.1"];
      endpoint = config.ip;
      isRelay = true;
      presharedKeySecret = null;
    };
    loser = {
      publicKey = "nL4DkJLnD/EwRGg+DHAsjDE2rg/hEibFb88b6Y7szBc=";
      privateKeyFile = config.sops.secrets.wg-loser-private-key.path;
      address = "10.100.0.2/24";
      allowedIPs = ["10.100.0.2"];
      presharedKeySecret = "wg-loser-psk";
    };
    winner = {
      publicKey = "qPEAvFY7/rwheiLX1Xn3EI1pnDmbF4VslClPmkDn10o=";
      privateKeyFile = config.sops.secrets.wg-winner-private-key.path;
      address = "10.100.0.3/24";
      allowedIPs = ["10.100.0.3"];
      presharedKeySecret = "wg-winner-psk";
    };
    vps = {
      publicKey = "uuRHwpFxt1Rfx7evsx7Q9ElnFuVA6ToAqHKigK+eIxk=";
      privateKeyFile = config.sops.secrets.wg-vps-private-key.path;
      address = "10.101.0.1/24";
      allowedIPs = ["10.101.0.1"];
      endpoint = "15.204.232.112";
      presharedKeySecret = "wg-vps-psk";
    };
  };
}
