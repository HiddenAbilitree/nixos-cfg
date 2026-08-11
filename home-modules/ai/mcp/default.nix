{
  config,
  lib,
  llm-agents,
  pkgs,
  ...
}:
let
  inherit (lib)
    concatMapStringsSep
    concatStringsSep
    escapeShellArg
    escapeShellArgs
    mapAttrs
    mapAttrsToList
    mkIf
    mkMerge
    mkOption
    optionalString
    types
    ;
  agents = llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
  configuredServers = config.ai.mcp.servers;
  serverNames = builtins.attrNames configuredServers;
  codexEnabled = config.ai.harnesses.codex.enable || config.ai.harnesses.oh-my-codex.enable;
  secretWrapper =
    name: server:
    pkgs.writeShellScriptBin "mcp-${name}" ''
      ${concatMapStringsSep "\n" (
        variable:
        "export ${variable}=\"$(${pkgs.coreutils}/bin/cat ${escapeShellArg server.secretEnv.${variable}})\""
      ) (builtins.attrNames server.secretEnv)}
      exec ${escapeShellArgs ([ server.command ] ++ server.args)}
    '';
  materializeServer =
    name: server:
    if server.type == "stdio" && server.secretEnv != { } then
      server
      // {
        command = "${secretWrapper name server}/bin/mcp-${name}";
        args = [ ];
      }
    else
      server;
  servers = mapAttrs materializeServer configuredServers;

  compact = lib.filterAttrs (_: value: value != null && value != { } && value != [ ]);
  toMcpJson =
    server:
    compact {
      inherit (server)
        type
        command
        args
        env
        url
        headers
        ;
    };
  mcpServersJson = mapAttrs (_: toMcpJson) servers;

  toClaudeJson = server: builtins.toJSON (toMcpJson server);

  envFlags =
    env:
    concatMapStringsSep " " (name: "--env ${escapeShellArg "${name}=${env.${name}}"}") (
      builtins.attrNames env
    );

  codexAdd =
    name: server:
    if server.type == "stdio" then
      ''
        ${agents.codex}/bin/codex mcp add ${escapeShellArg name} ${envFlags server.env} -- ${
          escapeShellArgs ([ server.command ] ++ server.args)
        }
      ''
    else
      ''
        ${agents.codex}/bin/codex mcp add ${escapeShellArg name} --url ${escapeShellArg server.url}${
          optionalString (
            server.bearerTokenEnvVar != null
          ) " --bearer-token-env-var ${escapeShellArg server.bearerTokenEnvVar}"
        }
      '';

  claudeAdd = name: server: ''
    ${agents.claude-code}/bin/claude mcp add-json ${escapeShellArg name} ${escapeShellArg (toClaudeJson server)} --scope user
  '';

  managedNames = pkgs.writeText "home-manager-ai-mcp-servers" (
    optionalString (serverNames != [ ]) "${concatStringsSep "\n" serverNames}\n"
  );
  syncServers =
    {
      binary,
      remove,
      additions,
      stateName,
    }:
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      state_dir=${escapeShellArg "${config.xdg.stateHome}/home-manager"}
      state_file="$state_dir/${stateName}"

      if [[ -f "$state_file" ]]; then
        while IFS= read -r server; do
          [[ -z "$server" ]] || ${binary} ${remove} "$server" >/dev/null 2>&1 || true
        done < "$state_file"
      fi

      ${additions}

      ${pkgs.coreutils}/bin/mkdir -p "$state_dir"
      ${pkgs.coreutils}/bin/cp ${managedNames} "$state_file"
    '';
in
{
  imports = [ ./servers.nix ];

  options.ai.mcp.servers = mkOption {
    default = { };
    description = "MCP servers applied to every enabled coding harness.";
    type = types.attrsOf (
      types.submodule (
        { name, ... }:
        {
          options = {
            type = mkOption {
              type = types.enum [
                "stdio"
                "http"
              ];
              default = "stdio";
              description = "Transport used by the ${name} MCP server.";
            };
            command = mkOption {
              type = types.nullOr types.str;
              default = null;
            };
            args = mkOption {
              type = types.listOf types.str;
              default = [ ];
            };
            env = mkOption {
              type = types.attrsOf types.str;
              default = { };
            };
            secretEnv = mkOption {
              type = types.attrsOf types.str;
              default = { };
              description = "Environment variables populated from secret files when the MCP server starts.";
            };
            url = mkOption {
              type = types.nullOr types.str;
              default = null;
            };
            headers = mkOption {
              type = types.attrsOf types.str;
              default = { };
            };
            bearerTokenEnvVar = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "Environment variable containing an HTTP bearer token.";
            };
          };
        }
      )
    );
  };

  config = mkMerge [
    {
      assertions = lib.concatLists (
        mapAttrsToList (name: server: [
          {
            assertion = server.type != "stdio" || server.command != null;
            message = "ai.mcp.servers.${name}.command is required for stdio servers";
          }
          {
            assertion = server.type == "stdio" || server.url != null;
            message = "ai.mcp.servers.${name}.url is required for HTTP servers";
          }
        ]) servers
      );
    }

    (mkIf codexEnabled {
      assertions = mapAttrsToList (name: server: {
        assertion = server.type != "http" || server.headers == { };
        message = "Codex cannot declaratively add static HTTP headers for ai.mcp.servers.${name}; use bearerTokenEnvVar instead";
      }) servers;
      home.activation.aiMcpCodex = syncServers {
        binary = "${agents.codex}/bin/codex";
        remove = "mcp remove";
        additions = concatStringsSep "" (mapAttrsToList codexAdd servers);
        stateName = "ai-mcp-codex-servers";
      };
    })

    (mkIf config.ai.harnesses.omp.enable {
      home.file.".omp/agent/mcp.json".text = builtins.toJSON {
        "$schema" =
          "https://raw.githubusercontent.com/can1357/oh-my-pi/main/packages/coding-agent/src/config/mcp-schema.json";
        mcpServers = mcpServersJson;
      };
    })

    (mkIf config.ai.harnesses.claude-code.enable {
      home.activation.aiMcpClaude = syncServers {
        binary = "${agents.claude-code}/bin/claude";
        remove = "mcp remove --scope user";
        additions = concatStringsSep "" (mapAttrsToList claudeAdd servers);
        stateName = "ai-mcp-claude-servers";
      };
    })

  ];
}
