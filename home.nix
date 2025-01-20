{
  pkgs,
  lib,
  osConfig,
  root,
  ...
}: {
  imports = [./hosts/${osConfig.networking.hostName}/home];
  nixpkgs.config.allowUnfree = true;

  programs = {
    git = {
      enable = true;
      userName = "Eric Zhang";
      userEmail = "eric@ericzhang.dev";
    };
    lazygit = {
      enable = true;
      settings = {
        gui.nerdFontsVersion = "3";
        git.overrideGpg = true;
      };
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      silent = true;
    };
  };

  home = {
    pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    username = "ezhang";
    homeDirectory = "/home/ezhang";

    sessionVariables = {
      EDITOR = "nvim";
      FLAKE = "${root}";
      YSU_HARDCORE = 1;
      XDG_CACHE_HOME = lib.mkForce "$HOME/.cache";
      XDG_CONFIG_HOME = lib.mkForce "$HOME/.config";
      XDG_DATA_HOME = lib.mkForce "$HOME/.local/share";
      XDG_STATE_HOME = lib.mkForce "$HOME/.local/state";
      BRAVE = pkgs.brave;
    };

    packages = with pkgs; [
      # cli/tuis
      age
      bat # fancy cat
      bluetuith
      dig
      glow # markdown renderer
      gum
      hyperfine
      hwinfo
      libqalculate
      nmap
      sops
      tldr # man pages
      wireguard-tools

      rustlings

      # utils
      colemak-dh
      hunspell
      hunspellDicts.en_US
      hyprls
      openconnect
      texliveFull
      xwaylandvideobridge
      glib
      wl-clipboard
      playerctl
      brightnessctl

      # development
      bun
      nodejs_23
      gh
    ];
    stateVersion = "24.05";
  };
  programs.home-manager.enable = true;
}
