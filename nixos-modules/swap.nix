{
  config,
  lib,
  ...
}: {
  options.swap.enable = lib.mkEnableOption "swap";

  config.swapDevices = lib.mkIf config.swap.enable [
    {
      device = "/swapfile";
      size = 16 * 1024;
    }
  ];
}
