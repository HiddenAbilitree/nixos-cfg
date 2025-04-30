{config, ...}: {
  services.mako = {
    inherit (config.desktop.notifications) enable;
    extraConfig = builtins.readFile ./mako.conf;
  };
}
