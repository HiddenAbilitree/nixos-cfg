{
  lib,
  config,
  ...
}:
lib.mkIf config.desktop.services.sunshine.enable {
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };
}
