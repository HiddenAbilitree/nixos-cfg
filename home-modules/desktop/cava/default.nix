{
  config,
  lib,
  ...
}: {
  options.desktop.cava.enable = lib.mkEnableOption "Cava";

  config = lib.mkIf config.desktop.cava.enable {
    programs.cava.enable = true;
  };
}
