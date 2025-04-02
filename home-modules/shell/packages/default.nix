{
  config,
  pkgs,
  lib,
  ...
}:
lib.mkIf config.shell.packages.enable {
  home.packages = with pkgs; [reptyr];
}
