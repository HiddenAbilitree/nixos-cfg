{
  config,
  lib,
  pkgs,
  spicetify-nix,
  ...
}: {
  options.desktop.spicetify.enable = lib.mkEnableOption "Spicetify";

  config = lib.mkIf config.desktop.spicetify.enable {
    programs.spicetify = let
      spicePkgs = spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in {
      enable = true;
      spotifyPackage = pkgs.spotify;
      enabledExtensions = with spicePkgs.extensions; [
        hidePodcasts
        shuffle
        oneko
        betterGenres
      ];
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "macchiato";
      windowManagerPatch = true;
    };
  };
}
