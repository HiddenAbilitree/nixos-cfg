{
  lib,
  config,
  pkgs,
  ...
}: {home.packages = with pkgs; lib.mkIf config.desktop.tor-browser.enable [tor-browser];}
