{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [./jj ./vscodium];

  options = {
    development = {
      enable = lib.mkEnableOption "development configuration";
      jj.enable = lib.mkEnableOption "jujutsu";
      vscodium.enable = lib.mkEnableOption "vscodium";
    };
  };

  config = {
    home.packages = with pkgs; lib.mkIf config.development.enable [man-pages man-pages-posix];
    development = lib.mkIf config.development.enable {
      jj.enable = lib.mkDefault true;
      vscodium.enable = lib.mkDefault true;
    };
  };
}
