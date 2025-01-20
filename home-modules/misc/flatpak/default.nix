{
  config,
  lib,
  ...
}: {
  services.flatpak = lib.mkIf config.misc.flatpak.enable {
    enable = true;
    uninstallUnmanaged = true;

    overrides = {
      global = {
        Context.sockets = ["wayland" "!x11" "!fallback-x11"];
      };
    };
  };
}
