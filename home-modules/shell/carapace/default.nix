{config, ...}: {
  programs.carapace = {
    inherit (config.shell.carapace) enable;
    enableNushellIntegration = true;
  };
}
