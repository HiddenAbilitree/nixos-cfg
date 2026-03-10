{
  config,
  lib,
  ...
}: {
  imports = [
    ./hyprland
    ./xserver
    ./fonts
    ./services
    ./games
  ];

  options.desktop.enable = lib.mkEnableOption "desktop";

  config = lib.mkIf config.desktop.enable {
    environment.sessionVariables.NIXOS_OZONE_WL = 1;

    services = {
      gnome.gnome-keyring.enable = true;
      power-profiles-daemon.enable = true;
    };

    desktop = {
      fonts.enable = lib.mkDefault true;
      hyprland.enable = lib.mkDefault true;
      xserver.enable = lib.mkDefault true;
      services.enable = lib.mkDefault true;
    };
  };
}
