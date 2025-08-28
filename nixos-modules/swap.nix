{
  config,
  lib,
  ...
}:
{
  swapDevices = lib.mkIf config.swap.enable [
    {
      device = "/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];
}
