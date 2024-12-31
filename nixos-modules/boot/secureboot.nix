{
  config,
  lib,
  ...
}: {
  boot = lib.mkIf config.bootx.secureboot.enable {
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    loader.systemd-boot.enable = false;
  };
}
