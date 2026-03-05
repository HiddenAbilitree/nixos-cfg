{config, ...}: {
  virtualisation.docker = {
    inherit (config.virtualization.docker) enable;
    daemon.settings.live-restore = false;
  };
}
