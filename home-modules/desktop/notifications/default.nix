{
  config,
  lib,
  ...
}: {
  options.desktop.notifications.enable = lib.mkEnableOption "Notifications";

  config = lib.mkIf config.desktop.notifications.enable {
    services.mako.enable = true;
    home.file.".config/mako/config".source = ./mako.conf;
  };
}
