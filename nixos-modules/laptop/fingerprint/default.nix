{
  lib,
  config,
  ...
}: {
  services.fprintd = lib.mkIf config.laptop.fingerprint.enable {
    enable = true; # fingerprint reader
  };
}
