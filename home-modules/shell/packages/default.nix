{
  config,
  lib,
  packages-nix,
  pkgs,
  slop,
  twopass,
  ...
}:
{
  options.shell.packages.enable = lib.mkEnableOption "misc packages (cli)";

  config = lib.mkIf config.shell.packages.enable {
    home.packages =
      with pkgs;
      [
        awscli2
        devenv
      ]
      ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
        dig
      ]
      ++ [
        ffmpeg
        libqalculate
        gdu
        wireguard-tools
        dua
        packages-nix.packages.${pkgs.stdenv.hostPlatform.system}.nix-bisect
        twopass.packages.${pkgs.stdenv.hostPlatform.system}.default
        slop.packages.${pkgs.stdenv.hostPlatform.system}.default
        statix
        nixfmt

      ]
      ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
        bluetuith
      ];
  };
}
