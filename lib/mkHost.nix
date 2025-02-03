{
  lib,
  inputs,
  ...
}: {
  mkHost = {
    hostName,
    system,
    secureboot,
    install,
  } @ args:
    lib.nixosSystem {
      inherit system;
      specialArgs =
        inputs // args;
      modules = [
        (../. + "/hosts/${hostName}")
        ../nixos.nix
        ../nixos-modules
        inputs.home-manager.nixosModules.home-manager
        inputs.disko.nixosModules.disko
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.private.nixosModules
        inputs.sops-nix.nixosModules.sops
        {
          environment.systemPackages = [inputs.alejandra.defaultPackage.${system}];
          networking.hostName = hostName;
          home-manager = {
            extraSpecialArgs =
              inputs
              // args
              // {
                root = "/home/ezhang/code/nix/nixos-cfg";
                proot = "/home/ezhang/code/nix/private-nixos-cfg";
                nroot = "/home/ezhang/code/nix/nixvim-cfg";
              };
            sharedModules = [
              inputs.spicetify-nix.homeManagerModules.default
              inputs.nix-flatpak.homeManagerModules.nix-flatpak
              inputs.private.homeManagerModules.private
              ../home-modules
            ];
            users.ezhang = import ../home.nix;
            useGlobalPkgs = true;
            useUserPackages = true;
          };
          bootx = {
            secureboot.enable = secureboot;
            install.enable = install;
          };
        }
      ];
    };
}
