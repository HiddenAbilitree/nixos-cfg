{
  lib,
  config,
  ...
}: {
  services.cloudflared = lib.mkIf config.server.cloudflared.enable {
    enable = true;
    user = "ezhang";
    tunnels = {
      "ericzhang.dev-1" = {
        credentialsFile = "/home/ezhang/.cloudflared/e6ac982a-c434-4d39-9e8a-b1b163f6b817.json";
        default = "http_status:404";
        ingress = {
          "grafana.ericzhang.dev" = {
            service = "http://localhost:3000";
          };
          "git.ericzhang.dev" = {
            service = "http://localhost:3001";
          };
        };
      };
    };
  };
}
