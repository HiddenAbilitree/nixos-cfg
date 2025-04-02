{
  config,
  lib,
  ...
}:
lib.mkIf config.shell.eza.enable {
  programs.eza = {
    enable = true;
    icons = "auto";
  };
}
