{ config, ... }:
{
  programs.nh = {
    inherit (config.shell.nh) enable;
    clean = {
      enable = true;
      extraArgs = "--keep-since 4d --keep 3 --nogcroots";
    };
  };
}
