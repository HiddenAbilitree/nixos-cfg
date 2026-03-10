{
  config,
  lib,
  ...
}: {
  options.virtualization.docker.enable = lib.mkEnableOption "docker";

  config = lib.mkIf config.virtualization.docker.enable {
    virtualisation.docker.enable = true;
  };
}
