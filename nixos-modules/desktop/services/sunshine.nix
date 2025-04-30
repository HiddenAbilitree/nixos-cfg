{config, ...}: {
  services.sunshine = {
    inherit (config.desktop.services.sunshine) enable;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };
}
