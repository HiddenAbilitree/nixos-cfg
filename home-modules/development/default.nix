{
  lib,
  config,
  ...
}: {
  imports = [./vscodium];

  options = {
    development = {
      enable = lib.mkEnableOption "development configuration";
      vscodium.enable = lib.mkEnableOption "vscodium";
    };
  };

  config = {
    development = lib.mkIf config.development.enable {
      vscodium.enable = lib.mkDefault true;
    };
  };
}
