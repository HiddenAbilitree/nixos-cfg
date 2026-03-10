{
  config,
  lib,
  ...
}: {
  options.shell.btop.enable = lib.mkEnableOption "btop";

  config = lib.mkIf config.shell.btop.enable {
    programs.btop = {
      enable = true;
      settings = {
        theme_background = false;
      };
    };
  };
}
