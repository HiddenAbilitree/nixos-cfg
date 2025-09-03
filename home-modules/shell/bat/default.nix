{config, ...}: {
  programs.bat = {
    inherit (config.shell.btop) enable;
    config.theme = "tokyonight_storm";
    themes.tokyonight_storm.src = ./tokyonight_storm.tmTheme;
  };
}
