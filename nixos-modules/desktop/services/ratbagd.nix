{ lib, config, ... }:
{
  services.ratbagd.enable = config.desktop.services.ratbagd.enable;
}
