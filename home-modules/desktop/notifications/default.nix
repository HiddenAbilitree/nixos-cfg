{config, ...}: {
  services.mako = {
    inherit (config.desktop.notifications) enable;
  };
  home.file = {
    ".config/mako/config" = {
      inherit (config.desktop.notifications) enable;
      source = ./mako.conf;
    };
  };
}
