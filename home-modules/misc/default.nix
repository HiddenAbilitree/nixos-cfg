{
  lib,
  config,
  ...
}: {
  imports = [./flatpak];
  options.misc = {
    enable = lib.mkEnableOption "misc configuration";
    flatpak.enable = lib.mkEnableOption "flatpak";
  };

  config.misc = lib.mkIf config.misc.enable {
    flatpak.enable = lib.mkDefault true;
  };
}
