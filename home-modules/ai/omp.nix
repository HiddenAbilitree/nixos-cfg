{
  config,
  lib,
  pkgs,
  ...
}:
let
  yaml = pkgs.formats.yaml { };
in
{
  options.ai.omp.settings = lib.mkOption {
    type = yaml.type;
    default = { };
    description = "Contents of ~/.omp/agent/config.yml.";
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

    home.file.".omp/agent/config.yml" = {
      source = yaml.generate "omp-config.yml" config.ai.omp.settings;
      force = true;
    };
  };
}
