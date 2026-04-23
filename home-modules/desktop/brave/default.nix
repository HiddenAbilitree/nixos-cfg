{
  config,
  lib,
  no-num-keys,
  brave-origin,
  pkgs,
  system,
  ...
}: let
  configDir = "${config.xdg.configHome}/BraveSoftware/Brave-Origin-Nightly";

  extensionJson = ext:
    lib.nameValuePair
    "${configDir}/External Extensions/${ext.id}.json"
    {
      text = builtins.toJSON (
        if ext ? crxPath
        then {
          external_crx = ext.crxPath;
          external_version = ext.version;
        }
        else {
          external_update_url = ext.updateUrl or "https://clients2.google.com/service/update2/crx";
        }
      );
    };

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
  ];
in {
  options.desktop.browser.enable = lib.mkEnableOption "Browser";

  config = lib.mkIf config.desktop.browser.enable {
    home.packages = [brave-origin.packages.${system}.default];
    home.file = lib.listToAttrs (map extensionJson extensions);
  };
}
