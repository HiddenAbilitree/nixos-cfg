{
  config,
  lib,
  ...
}: {
  programs.tmux = lib.mkIf config.shell.tmux.enable {
    enable = true;
    sensibleOnTop = true;
  };
}
