{
  description = "loser flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # master or nixos-unstable

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:Mic92/sops-nix";

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
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
      specialArgs = {
        inherit inputs;
      };

      universalModules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        sops-nix.nixosModules.sops
      ];

    in
    {
      nixosConfigurations = {
        loser = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = specialArgs;
          modules = [
            ./fw13
            ./utils/hibernate.nix
            lanzaboote.nixosModules.lanzaboote
            {
              home-manager.extraSpecialArgs = inputs // {
                root = "~/nixos-cfg";
              };
              networking.hostName = "loser";
            }
          ] ++ universalModules;
        };
        winner = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = specialArgs;
          modules = [
            ./bpc
            {
              home-manager.extraSpecialArgs = inputs // {
                root = "~/nixos-cfg";
              };
              networking.hostName = "winner";
            }

          ] ++ universalModules;
        };
      };
    };
}
