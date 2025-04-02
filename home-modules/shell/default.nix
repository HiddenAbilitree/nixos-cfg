{
  config,
  lib,
  ...
}: {
  imports = [
    ./atuin
    ./btop
    ./eza
    ./fastfetch
    ./jj
    ./nh
    ./nvim
    ./packages
    ./starship
    ./tmux
    ./zellij
    ./zoxide
    ./zsh
  ];

  options.shell = {
    enable = lib.mkEnableOption "shell configuration";
    atuin.enable = lib.mkEnableOption "Atuin";
    btop.enable = lib.mkEnableOption "btop";
    eza.enable = lib.mkEnableOption "eza";
    fastfetch.enable = lib.mkEnableOption "fastfetch";
    jj.enable = lib.mkEnableOption "Jujutsu";
    nh.enable = lib.mkEnableOption "nh";
    nvim.enable = lib.mkEnableOption "nvim";
    packages.enable = lib.mkEnableOption "misc packages (cli)";
    starship.enable = lib.mkEnableOption "Starship";
    tmux.enable = lib.mkEnableOption "tmux";
    zellij.enable = lib.mkEnableOption "Zellij";
    zoxide.enable = lib.mkEnableOption "Zoxide";
    zsh.enable = lib.mkEnableOption "zsh";
  };

  config.shell = lib.mkIf config.shell.enable {
    atuin.enable = lib.mkDefault true;
    btop.enable = lib.mkDefault true;
    eza.enable = lib.mkDefault true;
    fastfetch.enable = lib.mkDefault true;
    jj.enable = lib.mkDefault true;
    nh.enable = lib.mkDefault true;
    nvim.enable = lib.mkDefault true;
    starship.enable = lib.mkDefault true;
    tmux.enable = lib.mkDefault true;
    zellij.enable = lib.mkDefault false;
    zoxide.enable = lib.mkDefault true;
    zsh.enable = lib.mkDefault true;
  };
}
