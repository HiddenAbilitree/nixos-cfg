{
  config,
  lib,
  ...
}: {
  options.desktop.browser.enable = lib.mkEnableOption "Browser";

  config = lib.mkIf config.desktop.browser.enable {
    programs.chromium = {
      enable = true;
      extensions = [
        {id = "nngceckbapebfimnlniiiahkandclblb";}
        {id = "fphegifdehlodcepfkgofelcenelpedj";}
        {id = "cndibmoanboadcifjkjbdpjgfedanolh";}
        {id = "enamippconapkdmgfgjchkhakpfinmaj";}
        {id = "kbfnbcaeplbcioakkpcpgfkobkghlhen";}
        {id = "fmkadmapgofadopljbjfkapdkoienihi";}
        {id = "hlepfoohegkhhmjieoechaddaejaokhf";}
        {id = "gebbhagfogifgggkldgodflihgfeippi";}
        {id = "mnjggcdmjocbbbhaepdhchncahnbgone";}
        {id = "bpaoeijjlplfjbagceilcgbkcdjbomjd";}
        {id = "dbepggeogbaibhgnhhndojpepiihcmeb";}
      ];
    };
  };
}
