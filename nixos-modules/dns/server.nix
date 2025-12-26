{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.internal-dns;
  wgCfg = config.wireguard;

  extractIP = addr: lib.head (lib.splitString "/" addr);

  wgHostsLines =
    lib.mapAttrsToList (
      name: peer: "${extractIP peer.address} ${name}.${cfg.domain}"
    )
    wgCfg.peers;

  extraHostsLines =
    lib.mapAttrsToList (
      name: ip: "${ip} ${name}"
    )
    cfg.extraHosts;

  hostsFile = pkgs.writeText "internal-hosts" (
    lib.concatStringsSep "\n" (wgHostsLines ++ extraHostsLines)
  );

  isRelay = wgCfg.peer != null && wgCfg.peers.${wgCfg.peer}.isRelay;
in
  lib.mkIf (cfg.enable && isRelay) {
    services.dnsmasq = {
      enable = true;
      settings = {
        interface = ["wg0" "lo"];
        bind-interfaces = true;

        server = cfg.upstream;

        no-resolv = true;

        local = "/${cfg.domain}/";
        domain = cfg.domain;

        addn-hosts = toString hostsFile;

        cache-size = 1000;
      };
    };

    networking.firewall.interfaces.wg0 = {
      allowedUDPPorts = [53];
      allowedTCPPorts = [53];
    };
  }
