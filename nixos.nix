{
  pkgs,
  lib,
  ...
}: {
  imports = [./users];

  nixpkgs.config.allowUnfree = true;

  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      systemd-boot = {
        enable = lib.mkDefault true;
        consoleMode = "max";
      };
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  environment = {
    systemPackages = with pkgs; [
      duf
      dmidecode
      fd
      fprintd
      fzf
      gnupg1
      jq
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
    sessionVariables.NIXOS_OZONE_WL = 1;
  };
  networking = {
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
      "9.9.9.9"
    ];
    networkmanager.enable = lib.mkDefault false;
    useNetworkd = true;
  };

  nix = {
    settings = {
      trusted-users = [
        "root"
        "ezhang"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
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

  hardware = {
    openrazer.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-tty;
  };

  services = {
    udev.packages = [
      (pkgs.writeTextFile {
        name = "drunkdeer-udev";
        text = ''
          SUBSYSTEM=="hidraw", ATTRS{idVendor}=="352d", ATTRS{idProduct}=="2383", TAG+="uaccess"
          SUBSYSTEM=="usb", ATTRS{idVendor}=="352d", ATTRS{idProduct}=="2383", TAG+="uaccess"
        '';
        destination = "/etc/udev/rules.d/70-drunkdeer.rules";
      })
    ];

    fwupd.enable = true; # firmware updates
    gnome.core-utilities.enable = false;

    # auto mount/unmount usb drives
    gvfs.enable = true;
    udisks2.enable = true;
  };

  # for audio purposes
  security.rtkit.enable = true;

  system.stateVersion = "24.05";
}
