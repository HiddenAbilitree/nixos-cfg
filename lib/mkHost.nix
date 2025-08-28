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
    modulesx,
  } @ args:
    lib.nixosSystem {
      inherit system;
      specialArgs = inputs // args;
      modules =
        [
          (../. + "/hosts/${hostName}")
          ../nixos.nix
          ../nixos-modules
          inputs.home-manager.nixosModules.home-manager
          inputs.disko.nixosModules.disko
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.private.nixosModules
          inputs.sops-nix.nixosModules.sops
          inputs.fonts.nixosModules
          {
            environment.systemPackages = [
              inputs.alejandra.defaultPackage.${system}
              inputs.twopass.packages.${system}.default
            ];
            networking.hostName = hostName;
            home-manager = {
              extraSpecialArgs =
                inputs
                // args
                // {
                  root = "/home/ezhang/code/nix/nixos-cfg";
                  proot = "/home/ezhang/code/nix/private-nixos-cfg";
                  nroot = "/home/ezhang/code/nix/nixvim-cfg";
                  froot = "/home/ezhang/code/nix/fonts";
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
        ]
        ++ modulesx;
    };
}
