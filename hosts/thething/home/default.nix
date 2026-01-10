{lib, ...}: {
  imports = [./programs];
  shell = {
    enable = true;
    zellij.autostart = false;
  };
  programs = {
    kitty.enable = lib.mkForce true;
    ghostty.enable = true;
  };
}
