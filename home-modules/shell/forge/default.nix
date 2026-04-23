{
  config,
  lib,
  llm-agents,
  pkgs,
  ...
}: let
  forge = llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.forge;
  forgeZshPlugin = pkgs.runCommand "forge-zsh-plugin" {} ''
    mkdir -p $out
    export HOME=$TMPDIR
    {
      ${forge}/bin/forge zsh plugin
      ${forge}/bin/forge zsh theme
    } > $out/forge.plugin.zsh
  '';
in {
  options.shell.forge.enable = lib.mkEnableOption "Forgecode";

  config = lib.mkIf config.shell.forge.enable {
    home.packages = [forge];
    programs.zsh.plugins = [
      {
        name = "forge";
        src = forgeZshPlugin;
      }
    ];
  };
}
