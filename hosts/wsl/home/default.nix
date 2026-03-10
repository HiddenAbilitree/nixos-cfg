{pkgs, ...}: {
  shell.enable = true;

  home.packages = with pkgs; [
    claude-code
  ];
}
