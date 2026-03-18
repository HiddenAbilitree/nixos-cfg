{
  config,
  lib,
  no-num-keys,
  pkgs,
  ...
}: {
  options.desktop.browser.enable = lib.mkEnableOption "Browser";

  config = lib.mkIf config.desktop.browser.enable {
    programs.brave = {
      enable = true;
      extensions = [
        {
          id = "fgicbpcgglhhhcmmcjcjnglhojpobbda";
          crxPath = "${no-num-keys.packages.${pkgs.stdenv.hostPlatform.system}.default}/no-num-keys.crx";
          version = "1.0.0";
        }
        {id = "nngceckbapebfimnlniiiahkandclblb";}
        {id = "fphegifdehlodcepfkgofelcenelpedj";}
        {id = "enamippconapkdmgfgjchkhakpfinmaj";}
        {id = "kbfnbcaeplbcioakkpcpgfkobkghlhen";}
        {id = "fmkadmapgofadopljbjfkapdkoienihi";}
        {id = "hlepfoohegkhhmjieoechaddaejaokhf";}
        {id = "gebbhagfogifgggkldgodflihgfeippi";}
        {id = "mnjggcdmjocbbbhaepdhchncahnbgone";}
        {id = "bpaoeijjlplfjbagceilcgbkcdjbomjd";}
        # {id = "dbepggeogbaibhgnhhndojpepiihcmeb";} # vimium
      ];
    };
  };
}
