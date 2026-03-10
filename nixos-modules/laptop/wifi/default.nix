{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.laptop.wifi.enable {};
}
