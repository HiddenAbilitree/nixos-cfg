{ config, ... }:
{
  services.flatpak = {
    inherit (config.misc.flatpak) enable;
    uninstallUnmanaged = true;

    overrides.global = {
      Context.sockets = [ "wayland" ];
      Environment.GTK_THEME = "Tokyonight-Dark";
    };
  };
}
