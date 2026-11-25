{
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  ai.mcp.servers = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    deadlock = {
      type = "http";
      url = "https://api.deadlock-api.com/v1/mcp";
    };
    dokploy = {
      command = "npx";
      args = [
        "-y"
        "@dokploy/mcp"
      ];
      env.DOKPLOY_URL = "https://dokploy.seer.nexus";
      secretEnv.DOKPLOY_API_KEY = osConfig.sops.secrets.dokploy-api-key.path;
    };
    doop = {
      type = "http";
      url = "https://doop.design/mcp";
      bearerTokenFile = osConfig.sops.secrets.doop-api-key.path;
    };
  };
}
