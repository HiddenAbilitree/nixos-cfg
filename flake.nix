{
  description = "loser flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # master or nixos-unstable
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    sops-nix.url = "github:Mic92/sops-nix";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      spicetify-nix,
      sops-nix,
      lanzaboote,
      ...
    }:
    {
      nixosConfigurations = {
        loser = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          system = "x86_64-linux";
          modules = [
            ./fw13
            ./nixos/configuration.nix
            ./fw13/hardware-configuration.nix
            {
              home-manager.users.ezhang = import ./fw13/home/home.nix;
              networking.hostName = "loser";
            }

            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
            lanzaboote.nixosModules.lanzaboote
          ];
        };
        winner = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./bpc
            ./nixos/configuration.nix
            ./bpc/hardware-configuration.nix
            {
              home-manager.users.ezhang = import ./bpc/home/home.nix;
              networking.hostName = "winner";
            }
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
          ];
        };
      };
    };
}
