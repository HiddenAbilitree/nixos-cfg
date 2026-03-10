{
  config,
  lib,
  ...
}: {
  options.shell.zellij = {
    enable = lib.mkEnableOption "Zellij";
    autostart = lib.mkEnableOption "Zellij autostart";
  };

  config = lib.mkIf config.shell.zellij.enable {
    programs.zellij = {
      enable = true;
      enableZshIntegration = config.shell.zellij.autostart;
      settings = {
        theme = "tokyo-night-storm";
        show_startup_tips = false;
      };
    };
  };
}
