{
  config,
  canvas-video-download,
  lib,
  no-num-keys,
  packages-nix,
  pkgs,
  system,
  ...
}:
let
  configDir = "${config.xdg.configHome}/BraveSoftware/Brave-Origin-Nightly";

  extensionJson =
    ext:
    lib.nameValuePair "${configDir}/External Extensions/${ext.id}.json" {
      text = builtins.toJSON (
        if ext ? crxPath then
          {
            external_crx = ext.crxPath;
            external_version = ext.version;
          }
        else
          {
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
    {
      id = "opnladikbboelmnajcpmnfoggnpcblfi";
      crxPath = "${canvas-video-download.packages.${pkgs.stdenv.hostPlatform.system}.default}/canvas-video-download.crx";
      version = "1.0.0";
    }
    { id = "nngceckbapebfimnlniiiahkandclblb"; }
    { id = "fphegifdehlodcepfkgofelcenelpedj"; }
    { id = "enamippconapkdmgfgjchkhakpfinmaj"; }
    { id = "kbfnbcaeplbcioakkpcpgfkobkghlhen"; }
    { id = "fmkadmapgofadopljbjfkapdkoienihi"; }
    { id = "hlepfoohegkhhmjieoechaddaejaokhf"; }
    { id = "gebbhagfogifgggkldgodflihgfeippi"; }
    { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; }
    { id = "bpaoeijjlplfjbagceilcgbkcdjbomjd"; }
  ];
in
{
  options.desktop.browser.enable = lib.mkEnableOption "Browser";

  config = lib.mkIf config.desktop.browser.enable {
    home.packages = [ packages-nix.packages.${system}.brave-origin ];
    home.file = lib.listToAttrs (map extensionJson extensions);
  };
}
