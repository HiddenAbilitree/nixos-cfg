{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf config.shell.jj.enable {
  programs.jujutsu = {
    enable = true;
    settings = {
      ui = {
        allow-init-native = true;
        default-command = "log";
      };
      user = {
        name = "Eric Zhang";
        email = "me@ericzhang.dev";
      };
      signing = {
        backend = "gpg";
        backends.gpg.allow-expired-keys = false;
        behavior = "own";
        inherit (config.programs.git.signing) key;
      };
    };
  };
  home.packages = with pkgs; [
    jjui
  ];
}
