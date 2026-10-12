{
  config,
  lib,
  pkgs,
  ...
}:
let
  json = pkgs.formats.json { };
  settings = json.generate "omp-settings.json" config.ai.omp.settings;
in
{
  options.ai.omp.settings = lib.mkOption {
    type = json.type;
    default = { };
    description = ''
      Settings merged into ~/.omp/agent/config.yml on activation. Only values that changed since
      the previous activation are written, so edits made from omp persist until the same setting
      changes here.
    '';
  };

  config = lib.mkIf config.ai.harnesses.omp.enable {
    ai.omp.settings = {
      modelRoles = {
        vision = "opencode-go/mimo-v2.5:high";
        designer = "opencode-go/qwen3.8-max:xhigh";
        advisor = "openai-codex/gpt-5.6-sol:max";
        default = "anthropic/claude-sonnet-5-5:high";
      };
      symbolPreset = "nerd";
      theme = {
        dark = "dark-tokyo-night";
        light = "light";
      };
      setupVersion = 2;
      disabledProviders = [
        "claude"
        "codex"
      ];
      dev.autoqaConsent = "granted";
      statusLine = {
        separator = "none";
        preset = "default";
        sessionAccent = true;
        transparent = false;
        compactThinkingLevel = false;
        showHookStatus = true;
      };
      tui = {
        textSizing = true;
        codexResetFireworks = false;
      };
      terminal.showProgress = false;
      defaultThinkingLevel = "auto";
      codexResets.autoRedeem = "no";
      hideThinkingBlock = true;
      browser.relay = true;
    };

    home.activation.ompSettings = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      (
        target=${lib.escapeShellArg "${config.home.homeDirectory}/.omp/agent/config.yml"}
        state=${lib.escapeShellArg "${config.xdg.stateHome}/home-manager/omp-settings.json"}
        live=$target
        base=$state
        [[ -e $live ]] || live=/dev/null
        [[ -e $base ]] || base=/dev/null
        merged=$(${lib.getExe pkgs.jaq} --slurp --from yaml --to yaml --from-file ${./omp-settings.jq} \
          --slurpfile base "$base" --slurpfile new ${settings} "$live")
        run install -D -m 600 /dev/stdin "$target" <<<"$merged"
        run install -D -m 644 ${settings} "$state"
      )
    '';
  };
}
