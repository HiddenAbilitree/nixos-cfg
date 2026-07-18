{
  alejandra,
  config,
  lib,
  llm-agents,
  nix-bisect,
  pkgs,
  slop,
  twopass,
  ...
}: {
  options.shell.packages.enable = lib.mkEnableOption "misc packages (cli)";

  config = lib.mkIf config.shell.packages.enable {
    home.packages = with pkgs;
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
        (nix-bisect.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (_: {
          # Upstream's Nix build has flaky process tests and omits integration fixtures.
          doCheck = false;
        }))
        twopass.packages.${pkgs.stdenv.hostPlatform.system}.default
        slop.packages.${pkgs.stdenv.hostPlatform.system}.default
        statix

        llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex
        llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.oh-my-codex
      ]
      ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
        alejandra.defaultPackage.${pkgs.stdenv.hostPlatform.system}
        bluetuith
      ]
      ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
        pkgs.alejandra
      ];
  };
}
