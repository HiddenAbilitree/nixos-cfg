{ config, ... }:
{
  programs.eza = {
    inherit (config.shell.eza) enable;
    icons = "auto";
    colors = "always";
    enableZshIntegration = true;
    enableNushellIntegration = false;
  };
}
