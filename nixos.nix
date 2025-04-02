{
  pkgs,
  lib,
  ...
}: {
  imports = [./users];

  nixpkgs.config.allowUnfree = true;

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = lib.mkDefault true;
        consoleMode = "max";
      };
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  environment.systemPackages = with pkgs; [
    dmidecode
    duf
    fd
    fprintd
    fzf
    gnupg1
    jq
    killall
    p7zip
    ripgrep
    sbctl
    unzip
    wget
    zip

    usbutils
    udiskie
    udisks
  ];
  networking = {
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
      "9.9.9.9"
    ];
    networkmanager.enable = lib.mkDefault false;
    useNetworkd = true;
  };

  nix.settings = {
    auto-optimise-store = true;

    trusted-users = [
      "ezhang"
    ];

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

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-tty;
  };

  services = {
    fwupd.enable = true; # firmware updates

    # auto mount/unmount usb drives
    gvfs.enable = true;
    udisks2.enable = true;
  };

  system.stateVersion = "24.05";
}
