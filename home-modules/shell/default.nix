{
  config,
  lib,
  ...
}: {
  imports = [./atuin ./btop ./eza ./fastfetch ./nvim ./starship ./zoxide ./zsh];
  options = {
    shell = {
      enable = lib.mkEnableOption "shell configuration";
      atuin.enable = lib.mkEnableOption "Atuin";
      btop.enable = lib.mkEnableOption "btop";
      eza.enable = lib.mkEnableOption "eza";
      fastfetch.enable = lib.mkEnableOption "fastfetch";
      nvim.enable = lib.mkEnableOption "nvim";
      starship.enable = lib.mkEnableOption "Starship";
      zellij.enable = lib.mkEnableOption "Zellij";
      zoxide.enable = lib.mkEnableOption "Zoxide";
      zsh.enable = lib.mkEnableOption "zsh";
    };
  };
  config = {
    shell = lib.mkIf config.shell.enable {
      atuin.enable = lib.mkDefault true;
      btop.enable = lib.mkDefault true;
      eza.enable = lib.mkDefault true;
      fastfetch.enable = lib.mkDefault true;
      nvim.enable = lib.mkDefault true;
      starship.enable = lib.mkDefault true;
      zellij.enable = lib.mkDefault true;
      zoxide.enable = lib.mkDefault true;
      zsh.enable = lib.mkDefault true;
    };
  };
}
