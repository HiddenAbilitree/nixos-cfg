{ config, ... }:
{
  virtualisation.docker = {
    inherit (config.virtualization.docker) enable;
  };
}
