{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.desktop.enable = lib.mkEnableOption "desktop";

  config = lib.mkIf config.desktop.enable {
    environment.systemPackages = [ pkgs.ghostty-bin ];
  };
}
