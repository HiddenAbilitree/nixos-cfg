{
  pkgs,
  spicetify-nix,
  config,
  ...
}: {
  programs.spicetify = let
    spicePkgs = spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  in {
    inherit (config.desktop.spicetify) enable;
    spotifyPackage = pkgs.spotify;
    enabledExtensions = with spicePkgs.extensions; [
      # https://github.com/Gerg-L/spicetify-nix/blob/master/docs/EXTENSIONS.md
      adblock
      hidePodcasts
      shuffle
      fullAppDisplay
      loopyLoop
      oneko
      betterGenres
      songStats
    ];
    # https://github.com/Gerg-L/spicetify-nix/blob/master/docs/THEMES.md
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "macchiato";
    windowManagerPatch = true;
  };
}
