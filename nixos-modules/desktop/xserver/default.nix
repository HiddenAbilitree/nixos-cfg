{
  config,
  lib,
  pkgs,
  ...
}: {
  options.desktop.xserver.enable = lib.mkEnableOption "xserver";

  config.services = lib.mkIf config.desktop.xserver.enable {
    xserver = {
      enable = true;
      excludePackages = [pkgs.xterm];
    };

    displayManager.gdm = {
      enable = true;
    };

    displayManager.defaultSession = lib.mkIf config.desktop.hyprland.enable (lib.mkDefault "hyprland");

    desktopManager.gnome.enable = false;
  };
}
