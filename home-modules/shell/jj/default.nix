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
      ui.allow-init-native = true;
      user = {
        name = "Eric Zhang";
        email = "me@ericzhang.dev";
      };
      signing = {
        sign-all = true;
        backend = "gpg";
        backends.gpg.allow-expired-keys = false;
        inherit (config.programs.git.signing) key;
      };
    };
  };
  home.packages = with pkgs; [
    jjui
  ];
}
