{
  config,
  lib,
  ...
}: {
  options.shell.bat.enable = lib.mkEnableOption "bat";

  config = lib.mkIf config.shell.bat.enable {
    programs.bat = {
      enable = true;
      config.theme = "tokyonight_storm";
      themes.tokyonight_storm.src = ./tokyonight_storm.tmTheme;
    };
  };
}
