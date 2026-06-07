{
  config,
  lib,
  ...
}: let
  browserCfg = config.home-manager.users.ezhang.desktop.browser;
in {
  config = lib.mkIf browserCfg.enable {
    environment.etc."brave/policies/managed/search-engines.json".text = builtins.toJSON {
      SiteSearchSettings = [
        {
          name = "NixOS Packages";
          shortcut = "np";
          url = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
        }
      ];
    };
  };
}
