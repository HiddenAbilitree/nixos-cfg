{
  config,
  lib,
  ...
}: {
  options.shell.tmux.enable = lib.mkEnableOption "tmux";

  config = lib.mkIf config.shell.tmux.enable {
    programs.tmux = {
      enable = true;
      terminal = "xterm-kitty";
      focusEvents = true;
      newSession = true;
      shortcut = "space";
      extraConfig = ''
        set-option -g allow-passthrough on
      '';
    };
  };
}
