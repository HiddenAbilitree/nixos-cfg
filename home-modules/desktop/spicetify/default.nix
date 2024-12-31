{
  pkgs,
  spicetify-nix,
  config,
  lib,
  ...
}: {
  programs.spicetify = let
    spicePkgs = spicetify-nix.legacyPackages.${pkgs.system};
  in
    lib.mkIf config.desktop.spicetify.enable {
      enable = true;
      enabledCustomApps = with spicePkgs.apps; [
        # https://github.com/Gerg-L/spicetify-nix/blob/master/docs/CUSTOMAPPS.md
      ];
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
    };
}
