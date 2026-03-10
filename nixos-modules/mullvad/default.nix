{
  config,
  lib,
  ...
}: {
  options = {
    mullvad = {
      enable = lib.mkEnableOption "mullvad";

      account-token-path = lib.mkOption {
        type = lib.types.path;
        default = config.sops.secrets.mullvad-account-token.path;
        description = "Path to Mullvad account token.";
      };

      obfuscation.mode = lib.mkOption {
        type = lib.types.enum [
          "auto"
          "on"
          "off"
          "udp2tcp"
          "shadowsocks"
        ];
        default = "off";
      };

      tunnel.wireguard = {
        quantum-resistant = lib.mkOption {
          type = lib.types.enum [
            "on"
            "off"
          ];
          description = "Enable quantum resistant encryption for WireGuard tunnels. (Preshared Keys)";
          default = "off";
        };
        daita = lib.mkOption {
          type = lib.types.enum [
            "on"
            "off"
          ];
          default = "off";
        };
        rotation-interval = lib.mkOption {
          type = lib.types.int;
          description = "The number of hours between WireGuard key rotations.";
          default = 168;
        };
        mtu = lib.mkOption {
          type = lib.types.int;
          default = 1440;
        };
      };
    };
  };

  config = lib.mkIf config.mullvad.enable {
    services.mullvad-vpn.enable = true;
  };
}
