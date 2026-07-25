{
  lib,
  osConfig,
  pkgs,
  root,
  ...
}:
{
  imports = [
    ./hosts/${osConfig.networking.hostName}/home
  ];

  home = {
    username = "ezhang";
    homeDirectory = if pkgs.stdenv.hostPlatform.isDarwin then "/Users/ezhang" else "/home/ezhang";
    sessionVariables = {
      EDITOR = "nvim";
      NH_FLAKE = root;
      YSU_HARDCORE = 1;
      XDG_CACHE_HOME = lib.mkForce "$HOME/.cache";
      XDG_CONFIG_HOME = lib.mkForce "$HOME/.config";
      XDG_DATA_HOME = lib.mkForce "$HOME/.local/share";
      XDG_STATE_HOME = lib.mkForce "$HOME/.local/state";
    };

    packages =
      with pkgs;
      [
        texliveFull

        bun
        python315
        uv
        cargo
        nodejs_latest
        rustlings
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [
        brightnessctl
        colemak-dh
        glib
        hyprls
        openconnect
        vpn-slice
        playerctl
        man-pages
        man-pages-posix
      ];
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
