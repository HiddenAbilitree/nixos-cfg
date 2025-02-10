{
  config,
  lib,
  ...
}:
lib.mkIf config.misc.flatpak.enable {
  services.flatpak = {
    enable = true;
    uninstallUnmanaged = true;

    overrides.global = {
      Context.sockets = ["wayland"];

      Environment = {
        GTK_THEME = "Tokyonight-Dark";
      };
    };
  };
}
