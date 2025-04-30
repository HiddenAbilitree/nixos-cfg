{config, ...}: {
  programs.zellij = {
    inherit (config.shell.zellij) enable;
    enableZshIntegration = config.shell.zellij.autostart;
    settings = {
      theme = "tokyo-night-storm";
      show_startup_tips = false;
    };
  };
}
