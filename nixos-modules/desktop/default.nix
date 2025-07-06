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

  networking.extraHosts =
    lib.mkIf config.home-manager.users.ezhang.desktop.games.moe.enable
    ''
      0.0.0.0 log-upload-os.hoyoverse.com
      0.0.0.0 sg-public-data-api.hoyoverse.com

      0.0.0.0 log-upload.mihoyo.com
      0.0.0.0 public-data-api.mihoyo.com
    '';
}
