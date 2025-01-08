{
  config,
  lib,
  ...
}: {
  programs.zellij = lib.mkIf config.shell.zellij.enable {
    enable = true;
    enableZshIntegration = true;
    settings.theme = "tokyo-night-storm";
  };
}
