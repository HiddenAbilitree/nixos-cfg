{
  config,
  lib,
  pkgs,
  ...
}: {
  services = lib.mkIf config.desktop.xserver.enable {
    xserver = {
      enable = true;
      excludePackages = [pkgs.xterm];
    };

    displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    desktopManager.gnome.enable = false;
  };
}
