{
  config,
  lib,
  ...
}:
lib.mkIf config.shell.nh.enable {
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 4d --keep 3 --nogcroots";
    };
  };
}
