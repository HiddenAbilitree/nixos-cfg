{
  pkgs,
  spicetify-nix,
  config,
  ...
}: {
  programs.spicetify = let
    spicePkgs = spicetify-nix.legacyPackages.${pkgs.system};
  in {
    enable = config.desktop.spicetify.enable;
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
      oldSidebar
      fullAlbumDate
      powerBar
    ];
    # https://github.com/Gerg-L/spicetify-nix/blob/master/docs/THEMES.md
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "macchiato";
    windowManagerPatch = true;
  };
}
