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
    ./forge
    ./gemini-cli
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

  options.shell.enable = lib.mkEnableOption "shell configuration";

  config = lib.mkIf config.shell.enable {
    home.file.".config/nixpkgs/config.nix".text = "{ allowUnfree = true; }";

    shell = {
      atuin.enable = lib.mkDefault true;
      bat.enable = lib.mkDefault true;
      btop.enable = lib.mkDefault true;
      carapace.enable = lib.mkDefault true;
      eza.enable = lib.mkDefault true;
      fastfetch.enable = lib.mkDefault true;
      forge.enable = lib.mkDefault true;
      gemini-cli.enable = lib.mkDefault false;
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
