{
  config,
  lib,
  llm-agents,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    optional
    ;
  agents = llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
  skillsDirectory = ./skills;
  skillNames = builtins.attrNames (
    lib.filterAttrs (_: type: type == "directory") (builtins.readDir skillsDirectory)
  );

  harnessPaths = {
    claude-code = ".claude/CLAUDE.md";
    codex = ".codex/AGENTS.md";
    oh-my-codex = ".codex/AGENTS.md";
    omp = ".agents/AGENTS.md";
  };

  packageFor = name: agents.${name};

  harnessOptions = lib.mapAttrs (
    name: agentsPath:
    let
      package = packageFor name;
    in
    {
      enable = mkEnableOption (package.meta.description or "the ${lib.getName package} coding harness");
      agentsPath = lib.mkOption {
        type = lib.types.str;
        default = agentsPath;
        description = "Home-relative path at which to link the shared AGENTS.md for this harness.";
      };
      skillsPath = lib.mkOption {
        type = lib.types.str;
        default = "${dirOf config.ai.harnesses.${name}.agentsPath}/skills";
        description = "Home-relative directory in which to link shared skills for this harness.";
      };
    }
  ) harnessPaths;

  enabledHarnesses = lib.filterAttrs (name: _: config.ai.harnesses.${name}.enable) harnessPaths;
  enabledAgentsPaths = lib.unique (
    lib.mapAttrsToList (name: _: config.ai.harnesses.${name}.agentsPath) enabledHarnesses
  );
  enabledSkillsPaths = lib.unique (
    lib.mapAttrsToList (name: _: config.ai.harnesses.${name}.skillsPath) enabledHarnesses
  );
  agentLinks = map (path: {
    name = path;
    value.source = ./AGENTS.md;
  }) (lib.unique ([ "AGENTS.md" ] ++ enabledAgentsPaths));
  skillLinks = lib.concatMap (
    skillsPath:
    map (skillName: {
      name = "${skillsPath}/${skillName}";
      value.source = skillsDirectory + "/${skillName}";
    }) skillNames
  ) enabledSkillsPaths;
  enabledPackages = lib.mapAttrsToList (name: _: packageFor name) enabledHarnesses;

in
{
  imports = [ ./mcp ];

  options.ai = {
    harnesses = harnessOptions;
    paseo.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.desktop.enable && pkgs.stdenv.hostPlatform.isLinux;
      description = "Whether to enable the Paseo desktop environment for coding agents.";
    };
  };

  config = {
    home.file = builtins.listToAttrs (agentLinks ++ skillLinks);
    home.packages = enabledPackages ++ optional config.ai.paseo.enable agents.paseo-desktop;
    programs.git.ignores = [
      ".omx"
      "**/.claude/settings.local.json"
    ];
  };
}
