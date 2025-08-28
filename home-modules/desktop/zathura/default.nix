{ config, ... }:
{
  programs.zathura = {
    inherit (config.desktop.zathura) enable;
    extraConfig = builtins.readFile ./.zathurarc;
  };
}
