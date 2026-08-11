{
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  ai.mcp.servers = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    dokploy = {
      command = "npx";
      args = [
        "-y"
        "@dokploy/mcp"
      ];
      env.DOKPLOY_URL = "https://dokploy.seer.nexus";
      secretEnv.DOKPLOY_API_KEY = osConfig.sops.secrets.dokploy-api-key.path;
    };
  };
}
