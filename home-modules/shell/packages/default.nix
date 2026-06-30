{
  alejandra,
  config,
  lib,
  llm-agents,
  pkgs,
  slop,
  twopass,
  ...
}: {
  options.shell.packages.enable = lib.mkEnableOption "misc packages (cli)";

  config = lib.mkIf config.shell.packages.enable {
    home.packages = with pkgs; [
      awscli2
      # amdgpu_top
      # rclone
      bluetuith
      # charm-freeze
      devenv
      dig
      ffmpeg
      # glow
      # gum
      # hwinfo
      # hyperfine
      # lean4
      libqalculate
      gdu
      # nmap
      # reptyr
      # oxlint
      # ruff
      # rustfmt
      # terraform
      # tldr
      # tokei
      # vhs
      wireguard-tools
      # xh
      dua
      # w3m
      twopass.packages.${pkgs.stdenv.hostPlatform.system}.default
      alejandra.defaultPackage.${pkgs.stdenv.hostPlatform.system}
      slop.packages.${pkgs.stdenv.hostPlatform.system}.default
      statix

      llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex
      llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.oh-my-codex
    ];
  };
}
