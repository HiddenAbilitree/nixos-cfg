{
  config,
  lib,
  ...
}: {
  virtualisation.docker = lib.mkIf config.virtualization.docker.enable {
    enable = true;
  };
}
