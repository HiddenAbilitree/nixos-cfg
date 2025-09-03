{
  config,
  lib,
  ...
}: {
  imports = [
    ./atuin
    ./bat
    ./btop
    ./carapace
    ./eza
    ./fastfetch
    ./helix
    ./jj
    ./nh
    ./nvim
    ./nushell
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
    bat.enable = lib.mkEnableOption "bat";
    btop.enable = lib.mkEnableOption "btop";
    carapace.enable = lib.mkEnableOption "carapace";
    eza.enable = lib.mkEnableOption "eza";
    fastfetch.enable = lib.mkEnableOption "fastfetch";
    helix.enable = lib.mkEnableOption "helix";
    jj.enable = lib.mkEnableOption "Jujutsu";
    nh.enable = lib.mkEnableOption "nh";
    nvim.enable = lib.mkEnableOption "nvim";
    nushell.enable = lib.mkEnableOption "nushell";
    packages.enable = lib.mkEnableOption "misc packages (cli)";
    starship.enable = lib.mkEnableOption "Starship";
    tmux.enable = lib.mkEnableOption "tmux";
    zellij = {
      enable = lib.mkEnableOption "Zellij";
      autostart = lib.mkEnableOption "Zellij autostart";
    };
    zoxide.enable = lib.mkEnableOption "Zoxide";
    zsh.enable = lib.mkEnableOption "zsh";
  };

  config = {
    home.file.".config/nixpkgs/config.nix".text = "{ allowUnfree = true; }";

    shell = lib.mkIf config.shell.enable {
      atuin.enable = lib.mkDefault true;
      bat.enable = lib.mkDefault true;
      btop.enable = lib.mkDefault true;
      carapace.enable = lib.mkDefault true;
      eza.enable = lib.mkDefault true;
      fastfetch.enable = lib.mkDefault true;
      helix.enable = lib.mkDefault true;
      jj.enable = lib.mkDefault false;
      nh.enable = lib.mkDefault true;
      nvim.enable = lib.mkDefault true;
      nushell.enable = lib.mkDefault false;
      packages.enable = lib.mkDefault true;
      starship.enable = lib.mkDefault true;
      tmux.enable = lib.mkDefault false;
      zellij = {
        enable = lib.mkDefault true;
        autostart = lib.mkDefault true;
      };
      zoxide.enable = lib.mkDefault true;
      zsh.enable = lib.mkDefault true;
    };
  };
}
