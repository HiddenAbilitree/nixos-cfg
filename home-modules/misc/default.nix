{
  lib,
  config,
  ...
}: {
  imports = [./nh ./flatpak];
  options = {
    misc = {
      enable = lib.mkEnableOption "misc configuration";
      nh.enable = lib.mkEnableOption "nh";
      flatpak.enable = lib.mkEnableOption "flatpak";
    };
  };

  config = {
    misc = lib.mkIf config.misc.enable {
      nh.enable = lib.mkDefault true;
      flatpak.enable = lib.mkDefault true;
    };
  };
}
