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

    # fw-fanctrl = {
    #   url = "github:TamtamHero/fw-fanctrl/packaging/nix";
    # };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprland.url = "git+ssh://git@github.com/hyprwm/Hyprland.git?rev=3577a6be31fa26539b4088ea07aa2221f84b132e&ref=main";

    twopass = {
      # url = "github:ultramicroscope/2pass?rev=248434d383d4b4cc8bf690965c100adf3093b0ba";
      url = "github:ultramicroscope/2pass";
      # url = "github:HiddenAbilitree/2pass";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    impermanence.url = "github:nix-community/impermanence";

    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.2";

    prismlauncher.url = "github:PrismLauncher/PrismLauncher";

    private.url = "git+ssh://git@github.com/HiddenAbilitree/private-nixos-cfg.git?ref=main";

    fonts.url = "git+ssh://git@github.com/HiddenAbilitree/fonts.git?ref=main";

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

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

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    swww.url = "github:LGFae/swww";

    split-monitor-workspaces = {
      # url = "git+ssh://git@github.com/Duckonaut/split-monitor-workspaces.git?rev=a8e39ff10dfb5ff451416a791a30388a8517e038&ref=main";
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };
    # split-monitor-workspaces = {
    #   url = "github:Duckonaut/split-monitor-workspaces";
    #   inputs.hyprland.follows = "hyprland"; # <- make sure this line is present for the plugin to work as intended
    # };
  };

  nixConfig = {
    extra-substituters = [
      "https://ezkea.cachix.org"
      "https://hyprland.cachix.org"
      "https://lanzaboote.cachix.org"
      "https://nix-community.cachix.org"
      "https://prismlauncher.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "lanzaboote.cachix.org-1:Nt9//zGmqkg1k5iu+B3bkj3OmHKjSw9pvf3faffLLNk="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "prismlauncher.cachix.org-1:9/n/FGyABA2jLUVfY+DEp4hKds/rwO+SCOtbOkDzd+c="
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
        modulesx = [inputs.nixos-hardware.nixosModules.framework-13-7040-amd];
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
        modulesx = [];
      };
      wsl = mkHost {
        hostName = "wsl";
        system = "x86_64-linux";
        secureboot = false;
        install = false;
        modulesx = [];
      };
    };
  };
}
