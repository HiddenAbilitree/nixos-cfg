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
    let
      universalModules = [
        ./nixos/configuration.nix
        home-manager.nixosModules.home-manager
        sops-nix.nixosModules.sops
      ];
    in
    {

      nixosConfigurations = {
        loser = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          system = "x86_64-linux";
          modules = [
            ./fw13
            lanzaboote.nixosModules.lanzaboote
          ] ++ universalModules;
        };
        winner = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./bpc
          ] ++ universalModules;
        };
      };
    };
}
