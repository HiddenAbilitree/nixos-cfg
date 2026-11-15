{
  config,
  lib,
  ...
}:
{
  imports = [
    ./brave
    ./hyprland
    ./xserver
    ./fonts
    ./services
    ./games
    ./obs
  ];

  options.desktop.enable = lib.mkEnableOption "desktop";

  config = lib.mkIf config.desktop.enable {
    environment.sessionVariables.NIXOS_OZONE_WL = 1;
    programs.kdeconnect.enable = true;

    nixpkgs.overlays = [
      (_: prev: {
        gnome-keyring = prev.gnome-keyring.overrideAttrs (old: {
          patches = (old.patches or [ ]) ++ [ ./patches/gnome-keyring-escape-multiline-secrets.patch ];
        });
      })
    ];

    services = {
      gnome.gnome-keyring.enable = true;
      power-profiles-daemon.enable = true;
    };

    desktop = {
      fonts.enable = lib.mkDefault true;
      hyprland.enable = lib.mkDefault true;
      obs.enable = lib.mkDefault true;
      xserver.enable = lib.mkDefault true;
      services.enable = lib.mkDefault true;
    };
  };
}
