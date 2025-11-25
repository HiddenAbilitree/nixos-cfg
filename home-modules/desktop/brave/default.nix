{config, ...}: {
  programs.chromium = {
    inherit (config.desktop.browser) enable;
    # package = pkgs.brave;
    # extraOpts = {
    #   "SyncDisabled" = true;
    # };

    # initialPrefs = {
    #   "browser" = {
    #     "show_home_button" = false;
    #   };
    #   "first_run_tabs" = [
    #     "https://outlook.office365.com/mail/"
    #     "https://mail.google.com/mail/u/0/"
    #   ];
    #   "distribution" = {
    #     "import_bookmarks" = false;
    #     # "import_bookmarks_from_file" = ; # sops file whenever I stop being lazy.
    #   };
    #   "bookmark_bar" = {
    #     "show_on_all_tabs" = true;
    #   };
    # };
    extensions = [
      {id = "nngceckbapebfimnlniiiahkandclblb";} # 7tv nightly
      {id = "fphegifdehlodcepfkgofelcenelpedj";} # better canvas
      {id = "cndibmoanboadcifjkjbdpjgfedanolh";} # bitwarden
      {id = "enamippconapkdmgfgjchkhakpfinmaj";} # dearrow
      {id = "kbfnbcaeplbcioakkpcpgfkobkghlhen";} # grammarly
      {id = "fmkadmapgofadopljbjfkapdkoienihi";} # react developer tools
      {id = "hlepfoohegkhhmjieoechaddaejaokhf";} # refined github
      {id = "gebbhagfogifgggkldgodflihgfeippi";} # return youtube dislike
      {id = "mnjggcdmjocbbbhaepdhchncahnbgone";} # sponsorblock
      {id = "bpaoeijjlplfjbagceilcgbkcdjbomjd";} # ttv lol pro
      {id = "dbepggeogbaibhgnhhndojpepiihcmeb";} # vimium
    ];
  };
}
