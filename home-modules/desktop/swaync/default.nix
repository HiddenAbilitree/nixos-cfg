{
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkIf config.desktop.swaync.enable {
    home.packages = with pkgs; [
      swaynotificationcenter
    ];

    services.swaync.enable = true;
  };
}
