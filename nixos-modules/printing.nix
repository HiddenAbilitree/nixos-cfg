{
  lib,
  config,
  ...
}: {
  services.avahi = lib.mkIf config.printing.enable {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
