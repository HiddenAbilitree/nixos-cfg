{
  config,
  lib,
  ...
}: {
  options.printing.enable = lib.mkEnableOption "printing";

  config = lib.mkIf config.printing.enable {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
