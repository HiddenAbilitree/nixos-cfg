{config, ...}: {
  virtualisation.docker = {
    inherit (config.virtualization.docker) enable;
    enableNvidia = true;
  };
  hardware.nvidia-container-toolkit = {inherit (config.virtualisation.docker) enable;};
}
