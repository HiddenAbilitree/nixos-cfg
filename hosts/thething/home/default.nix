{lib, ...}: {
  imports = [./programs];
  shell.enable = true;
  programs = {
    kitty.enable = lib.mkForce true;
    ghostty.enable = true;
  };
}
