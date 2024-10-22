{
  config,
  pkgs,
  inputs,
  ...
}:
{
  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    loader.systemd-boot.enable = false;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.networkmanager.enable = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  time = {
    timeZone = "America/New_York";
    hardwareClockInLocalTime = true;
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];

  users.users.ezhang = {
    isNormalUser = true;
    description = "Eric Zhang";
    extraGroups = [
      "networkmanager"
      "wheel"
      "openrazer"
    ];
    packages = with pkgs; [ ];
    shell = pkgs.zsh;
  };

  fonts = {
    packages = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "JetBrainsMono"
        ];
      })
      inter
      dejavu_fonts
      noto-fonts
      noto-fonts-extra
      babelstone-han
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      ubuntu_font_family
      liberation_ttf
    ];

    fontconfig.defaultFonts = {
      monospace = [
        "JetBrains Mono"
        "FiraCode"
        "DejaVu Sans Mono"
        "Noto Sans Mono CJK SC"
        "Noto Sans Mono CJK TC"
      ];

      sansSerif = [
        "Inter"
        "DejaVu Sans"
        "Noto Sans CJK SC"
        "Noto Sans CJK TC"
        "JetBrains Mono"
        "FiraCode"
      ];

      serif = [
        "DejaVu Serif"
        "Noto Serif CJK SC"
        "Noto Serif CJK TC"
        "JetBrains Mono"
        "FiraCode"

      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=yes
    AllowHybridSleep=yes
    AllowSuspendThenHibernate=yes
  '';

  hardware = {
    openrazer.enable = true;
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = 1;
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    };

    systemPackages = with pkgs; [
      fprintd

      (catppuccin-sddm.override {
        flavor = "macchiato";
        font = "JetBrainsMono";
        fontSize = "12";
        loginBackground = true;
      })

      # utils
      sbctl
      nixfmt-rfc-style
      ripgrep
      fd
      glib
      wget
      openrazer-daemon
      wl-clipboard
      playerctl
      brightnessctl
      p7zip
      zip
      unzip
    ];
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = inputs;

  programs = {
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/ezhang/nixos-cfg";
    };

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-tty;
    };

    thunar.enable = true;

    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    zsh.enable = true;
  };

  services = {
    gvfs.enable = true;
    fwupd.enable = true; # firmware updates
    fprintd.enable = true;

    displayManager = {
      sddm = {
        enable = false;
        wayland.enable = true;
        theme = "catppuccin-macchiato";
        package = pkgs.kdePackages.sddm;
      };
    };

    xserver = {
      enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };

      excludePackages = [ pkgs.xterm ];

      desktopManager.gnome = {
        enable = false;
      };

      xkb = {
        layout = "us";
        variant = "";
      };
    };

    gnome.core-utilities.enable = false;

    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };

  # for audio purposes
  security.rtkit.enable = true;

  system.stateVersion = "24.05";
}
