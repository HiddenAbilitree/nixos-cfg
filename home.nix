{
  pkgs,
  lib,
  osConfig,
  root,
  ...
}: {
  imports = [./hosts/${osConfig.networking.hostName}/home];

  home = {
    username = "ezhang";
    homeDirectory = "/home/ezhang";

    sessionVariables = {
      EDITOR = "nvim";
      FLAKE = root;
      YSU_HARDCORE = 1;
      XDG_CACHE_HOME = lib.mkForce "$HOME/.cache";
      XDG_CONFIG_HOME = lib.mkForce "$HOME/.config";
      XDG_DATA_HOME = lib.mkForce "$HOME/.local/share";
      XDG_STATE_HOME = lib.mkForce "$HOME/.local/state";
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

      # utils
      brightnessctl
      colemak-dh
      glib
      hunspell
      hunspellDicts.en_US
      hyprls
      openconnect
      playerctl
      texliveFull
      wl-clipboard

      # development
      bun
      gh
      man-pages
      man-pages-posix
      nodejs_23
      rustlings
    ];
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
