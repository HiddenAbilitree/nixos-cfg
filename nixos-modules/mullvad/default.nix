{
  lib,
  config,
  ...
}:
{
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

    # systemd.services."mullvad-daemon".postStart = let
    #   mullvad = config.services.mullvad-vpn.package;
    # in ''
    #   while ! ${mullvad}/bin/mullvad status >/dev/null; do sleep 5; done
    #   ${mullvad}/bin/mullvad account login | echo ${config.mullvad.account-token-path}
    #   ${mullvad}/bin/mullvad auto-connect set on
    #   ${mullvad}/bin/mullvad set default --block-ads --block-trackers --block-malware
    #   ${mullvad}/bin/mullvad tunnel set \
    #   --quantum-resistant ${config.mullvad.tunnel.wireguard.quantum-resistant} \
    #   --daita ${config.mullvad.tunnel.wireguard.daita} \
    #   --rotation-interval ${toString config.mullvad.tunnel.wireguard.rotation-interval} \
    #   --mtu ${toString config.mullvad.tunnel.wireguard.mtu}
    #   ${mullvad}/bin/mullvad obfuscation set mode ${config.mullvad.obfuscation.mode}
    # '';
  };
}
