{
  config,
  lib,
  ...
}:
lib.mkIf config.shell.zellij.enable {
  programs.zellij = {
    enable = true;
    enableZshIntegration = config.shell.zellij.autostart;
    settings.theme = "tokyo-night-storm";
  };
}
