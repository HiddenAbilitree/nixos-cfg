{ inputs, ... }: {
  mkDarwinHost =
    {
      hostName,
      system,
    }@args:
    inputs.nix-darwin.lib.darwinSystem {
      specialArgs = inputs // args;
      modules = [
        ../darwin.nix
        ../darwin-modules
        (../. + "/hosts/${hostName}")
        inputs.home-manager.darwinModules.home-manager
        {
          nixpkgs.hostPlatform = system;
          networking.hostName = hostName;

          home-manager = {
            extraSpecialArgs =
              inputs
              // args
              // {
                root = "/Users/ezhang/code/nix/nixos-cfg";
                proot = "/Users/ezhang/code/nix/private-nixos-cfg";
                nroot = "/Users/ezhang/code/nix/nixvim-cfg";
              };
            sharedModules = [
              inputs.spicetify-nix.homeManagerModules.default
              ../home-modules
            ];
            users.ezhang = import ../home.nix;
            useGlobalPkgs = true;
            useUserPackages = true;
          };
        }
      ];
    };
}
