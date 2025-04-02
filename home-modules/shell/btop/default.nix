{
  config,
  lib,
  ...
}:
lib.mkIf config.shell.btop.enable
{
  programs.btop = {
    enable = true;
    settings = {
      theme_background = false;
    };
  };
}
