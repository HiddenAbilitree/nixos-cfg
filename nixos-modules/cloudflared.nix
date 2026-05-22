{
  config,
  lib,
  ...
}: {
  options.cloudflared.enable = lib.mkEnableOption "Cloudflared Tunnels";

  config = lib.mkIf config.cloudflared.enable {
    services.cloudflared = {
      enable = true;
      tunnels = {
        "ericzhang.dev-1" = {
          credentialsFile = "/home/ezhang/.cloudflared/e6ac982a-c434-4d39-9e8a-b1b163f6b817.json";
          default = "http_status:404";
          ingress = {
            "grafana.ericzhang.dev" = {
              service = "http://localhost:${toString config.observability.grafanaPort}";
            };
            "git.ericzhang.dev" = {
              service = "http://localhost:3001";
            };
          };
        };
      };
    };
  };
}
