{
  config,
  lib,
  ...
}: {
  imports = [./flatpak];

  options.misc.enable = lib.mkEnableOption "misc configuration";

  config.misc = lib.mkIf config.misc.enable {
    flatpak.enable = lib.mkDefault true;
  };
}
