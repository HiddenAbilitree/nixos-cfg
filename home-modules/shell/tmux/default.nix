{
  config,
  pkgs,
  ...
}: {
  programs.tmux = {
    inherit (config.shell.tmux) enable;
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
