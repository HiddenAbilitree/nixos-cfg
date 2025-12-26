{lib, ...}: {
  imports = [
    ./server.nix
  ];

  options.internal-dns = {
    enable = lib.mkEnableOption "Internal DNS server for WireGuard";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "wg";
      description = "Internal domain suffix";
    };

    upstream = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["1.1.1.1" "1.0.0.1"];
      description = "Upstream DNS servers for non-internal queries";
    };

    extraHosts = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Additional hostname -> IP mappings";
      example = {
        "grafana.wg" = "10.100.0.1";
        "git.wg" = "10.100.0.1";
      };
    };
  };
}
