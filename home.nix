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
      NH_FLAKE = root;
      YSU_HARDCORE = 1;
      XDG_CACHE_HOME = lib.mkForce "$HOME/.cache";
      XDG_CONFIG_HOME = lib.mkForce "$HOME/.config";
      XDG_DATA_HOME = lib.mkForce "$HOME/.local/share";
      XDG_STATE_HOME = lib.mkForce "$HOME/.local/state";
    };

    packages = with pkgs; [
      # cli/tuis

      # utils
      brightnessctl
      colemak-dh
      glib
      hyprls
      openconnect
      vpn-slice
      playerctl
      texliveFull

      # development
      bun
      cargo
      nodejs_latest
      gh
      man-pages
      man-pages-posix
      python3
      rustlings
    ];
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
