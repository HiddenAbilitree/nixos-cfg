{
  config,
  lib,
  ...
}: {
  services.fprintd = lib.mkIf config.laptop.fingerprint.enable {
    enable = true;
  };
}
