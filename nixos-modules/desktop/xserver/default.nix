{
  config,
  lib,
  pkgs,
  ...
}: {
  services.xserver = lib.mkIf config.desktop.xserver.enable {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    excludePackages = [pkgs.xterm];

    desktopManager.gnome = {
      enable = false;
    };
  };
}
