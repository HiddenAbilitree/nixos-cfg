{
  lib,
  config,
  ...
}: {
  imports = [./nh];
  options = {
    misc = {
      enable = lib.mkEnableOption "misc configuration";
      nh.enable = lib.mkEnableOption "nh";
    };
  };

  config = {
    misc = lib.mkIf config.misc.enable {
      nh.enable = lib.mkDefault true;
    };
  };
}
