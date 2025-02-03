{
  description = "loser flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # master or nixos-unstable

    alejandra = {
      url = "github:kamadorueda/alejandra/3.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "git+ssh://git@github.com/hyprwm/Hyprland.git?rev=b9f110ef8726fcba2b4ee69856027731e73003a5&ref=main";

    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.2";

    private.url = "git+ssh://git@github.com/HiddenAbilitree/private-nixos-cfg.git?ref=main";

    nixvim-cfg = {
      url = "github:HiddenAbilitree/nixvim-cfg";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    split-monitor-workspaces = {
      url = "git+ssh://git@github.com/Duckonaut/split-monitor-workspaces.git?rev=c75ec3a643a98169acdea03336c06f3656fe0e76&ref=main";
      inputs.hyprland.follows = "hyprland";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
      "https://lanzaboote.cachix.org"
    ];
    trusted-public-keys = [
      "lanzaboote.cachix.org-1:Nt9//zGmqkg1k5iu+B3bkj3OmHKjSw9pvf3faffLLNk="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  outputs = {nixpkgs, ...} @ inputs: let
    inherit (nixpkgs) lib;
    inherit ((import ./lib/mkHost.nix {inherit lib inputs;})) mkHost;
  in {
    nixosConfigurations = {
      loser = mkHost {
        hostName = "loser";
        system = "x86_64-linux";
        secureboot = true;
        install = false;
      };
      winner = mkHost {
        hostName = "winner";
        system = "x86_64-linux";
        secureboot = true;
        install = false;
      };
      thething = mkHost {
        hostName = "thething";
        system = "x86_64-linux";
        secureboot = false;
        install = false;
      };
    };
  };
}
