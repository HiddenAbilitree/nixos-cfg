{
  config,
  lib,
  ...
}: {
  options.misc.flatpak.enable = lib.mkEnableOption "flatpak";

  config = lib.mkIf config.misc.flatpak.enable {
    services.flatpak = {
      enable = true;
      uninstallUnmanaged = true;

      packages = [
        "com.hypixel.HytaleLauncher"
      ];

      overrides.global = {
        Context.sockets = ["wayland"];
        Environment.GTK_THEME = "Tokyonight-Dark";
      };
    };
  };
}
