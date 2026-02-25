{config, ...}: {
  virtualisation.docker = {
    inherit (config.virtualization.docker) enable;
    virtualisation.docker.daemon.settings.live-restore = false;
  };
}
