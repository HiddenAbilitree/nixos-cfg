{config, ...}: {
  programs.cava = {
    inherit (config.desktop.cava) enable;
  };
}
