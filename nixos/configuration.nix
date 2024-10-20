# Edit this configuration file to define what should be installed on
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{

  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Set your time zone.
  time = {
    timeZone = "America/New_York";
    hardwareClockInLocalTime = true;
  };

  # Select internationalisation properties.
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
  # Configure keymap in X11

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
        "JetBrains Mono"
        "FiraCode"
        "DejaVu Sans"
        "Noto Sans CJK SC"
        "Noto Sans CJK TC"
      ];

      serif = [
        "JetBrains Mono"
        "FiraCode"
        "DejaVu Serif"
        "Noto Serif CJK SC"
        "Noto Serif CJK TC"
      ];
    };
  };
  # allow unfree haha
  nixpkgs.config.allowUnfree = true;

  hardware = {
    openrazer.enable = true;
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };

  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages = with pkgs; [
      firefox
      fprintd

      (catppuccin-sddm.override {
        flavor = "macchiato";
        font = "JetBrainsMono";
        fontSize = "12";
        # # background = "${./wallpaper.png}";
        loginBackground = true;
      })

      # utils
      nixfmt-rfc-style
      ripgrep
      fd
      glib
      wget
      openrazer-daemon
      wl-clipboard
      playerctl
      brightnessctl
      zip
      unzip
    ];
  };

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-tty;
    };

    zsh.enable = true;

    thunar.enable = true;

    hyprland.enable = true;
  };

  services = {
    gvfs.enable = true;
    fwupd.enable = true; # firmware updates
    # pcscd.enable = true;
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

      #alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };
  };

  # audio
  security.rtkit.enable = true;

  system.stateVersion = "24.05";
}
