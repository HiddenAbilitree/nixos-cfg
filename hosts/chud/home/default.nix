{
  imports = [./programs];

  shell = {
    enable = true;
    zellij.autostart = false;
  };

  desktop.enable = true;
}
