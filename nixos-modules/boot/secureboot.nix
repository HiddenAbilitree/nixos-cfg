{
  config,
  lib,
  ...
}: {
  options.bootx.secureboot.enable = lib.mkEnableOption "secureboot";

  config.boot = lib.mkIf config.bootx.secureboot.enable {
    lanzaboote = {
      enable = true;
      pkiBundle = lib.mkDefault "/etc/secureboot";
    };
    loader.systemd-boot.enable = false;
  };
}
