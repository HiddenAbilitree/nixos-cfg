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

    hyprland.url = "git+ssh://git@github.com/hyprwm/Hyprland.git?rev=54441e0c4e51dd182f78876c014446d5d0359ba8&ref=main";

    # hyprland.url = "github:hyprwm/Hyprland";

    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.2";

    private.url = "git+ssh://git@github.com/HiddenAbilitree/private-nixos-cfg.git?ref=main";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixvim-cfg = {
      url = "git+ssh://git@github.com/HiddenAbilitree/nixvim-cfg.git?ref=main";
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
      url = "git+ssh://git@github.com/Duckonaut/split-monitor-workspaces.git?rev=917e9ad52e910ffa0ab7d61fecd5a2e3d3f66d87&ref=main";
      inputs.hyprland.follows = "hyprland";
    };
    # split-monitor-workspaces = {
    #   url = "github:Duckonaut/split-monitor-workspaces";
    #   inputs.hyprland.follows = "hyprland"; # <- make sure this line is present for the plugin to work as intended
    # };
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
        modulesx = [];
      };
      winner = mkHost {
        hostName = "winner";
        system = "x86_64-linux";
        secureboot = true;
        install = false;
        modulesx = [];
      };
      thething = mkHost {
        hostName = "thething";
        system = "x86_64-linux";
        secureboot = false;
        install = false;
        modulesx = [inputs.nixos-hardware.nixosModules.framework-13-7040-amd];
      };
    };
  };
}
