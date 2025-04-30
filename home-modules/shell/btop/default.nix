{config, ...}: {
  programs.btop = {
    inherit (config.shell.btop) enable;
    settings = {
      theme_background = false;
    };
  };
}
