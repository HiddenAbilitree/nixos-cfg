{
  lib,
  config,
  pkgs,
  ...
}: {
  services.fprintd = lib.mkIf config.laptop.fingerprint.enable {
    enable = true; # fingerprint reader
    tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-vfs0090;
    };
  };
}
