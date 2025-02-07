{
  lib,
  config,
  ...
}: {
  imports = [
    ./hyprland
    ./xserver
    ./fonts
    ./services
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = lib.mkIf config.desktop.enable 1;
}
