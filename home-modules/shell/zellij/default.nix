{
  config,
  lib,
  ...
}:
lib.mkIf config.shell.zellij.enable {
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    settings.theme = "tokyo-night-storm";
  };
}
