{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.tmux = lib.mkIf config.shell.tmux.enable {
    enable = true;
    terminal = "xterm-kitty";
    focusEvents = true;
    newSession = true;
    shortcut = "space";
    shell = "${pkgs.zsh}/bin/zsh";
    extraConfig = ''
      set-option -g allow-passthrough on
    '';
  };
}
