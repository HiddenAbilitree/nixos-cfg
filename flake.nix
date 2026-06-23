{
  description = "loser flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    alejandra = {
      url = "github:kamadorueda/alejandra";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    brave-origin = {
      url = "git+ssh://git@github.com/HiddenAbilitree/brave-origin-nix.git?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deadworks-nix = {
      url = "git+ssh://git@github.com/HiddenAbilitree/deadworks-nix.git?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    paper = {
      url = "git+ssh://git@github.com/HiddenAbilitree/paper-nix.git?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    awww.url = "git+https://codeberg.org/LGFae/awww";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fonts.url = "git+ssh://git@github.com/HiddenAbilitree/fonts.git?ref=main";

    helium = {
      url = "github:forkprince/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    impermanence.url = "github:nix-community/impermanence";

    kitty = {
      url = "git+ssh://git@github.com/HiddenAbilitree/kitty-nix.git?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/0403b4b7e8b2612657f0053a4c315e6c43eee9e6";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-dokploy.url = "github:el-kurto/nix-dokploy";

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim-cfg.url = "git+ssh://git@github.com/HiddenAbilitree/nixvim-cfg.git?ref=main";

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    no-num-keys.url = "git+ssh://git@github.com/HiddenAbilitree/no-num-keys.git?ref=main";

    prismlauncher.url = "github:PrismLauncher/PrismLauncher";

    private.url = "git+ssh://git@github.com/HiddenAbilitree/private-nixos-cfg.git?ref=main";
    # private.url = "path:/home/ezhang/code/nix/private-nixos-cfg";
    # fonts.url = "path:/home/ezhang/code/nix/fonts";
    # nixvim-cfg.url = "path:/home/ezhang/code/nix/nixvim-cfg";

    slop.url = "git+ssh://git@github.com/HiddenAbilitree/slop.git?ref=main";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };

    twopass = {
      url = "github:ultramicroscope/2pass";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vicinae = {
      url = "github:vicinaehq/vicinae";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vite-plus = {
      url = "git+ssh://git@github.com/HiddenAbilitree/vite-plus-nix.git?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://noctalia.cachix.org"
      "https://ezkea.cachix.org"
      "https://hyprland.cachix.org"
      "https://lanzaboote.cachix.org"
      "https://nix-community.cachix.org"
      "https://prismlauncher.cachix.org"
      "https://vicinae.cachix.org"
      "https://cache.numtide.com"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "lanzaboote.cachix.org-1:Nt9//zGmqkg1k5iu+B3bkj3OmHKjSw9pvf3faffLLNk="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "prismlauncher.cachix.org-1:9/n/FGyABA2jLUVfY+DEp4hKds/rwO+SCOtbOkDzd+c="
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
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
        modulesx = [inputs.nix-dokploy.nixosModules.default];
      };
      wsl = mkHost {
        hostName = "wsl";
        system = "x86_64-linux";
        secureboot = false;
        install = false;
        modulesx = [inputs.nixos-wsl.nixosModules.default];
      };
    };
  };
}
