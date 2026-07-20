{
  config,
  pkgs,
  ...
}: {
  imports = [./users];

  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
    android_sdk.accept_license = true;
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
    zsh

    usbutils
    udiskie
    udisks
  ];

  networking = {
    networkmanager.enable = true;
    useNetworkd = true;
  };

  sops.templates."nix-access-tokens" = {
    content = ''
      access-tokens = github.com=${config.sops.placeholder.github-token}
    '';
    owner = "ezhang";
    mode = "0400";
    restartUnits = ["nix-daemon.service"];
  };

  nix.extraOptions = ''
    !include ${config.sops.templates."nix-access-tokens".path}
  '';

  nix.settings = {
    auto-optimise-store = true;

    download-buffer-size = 524288000;

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
    fwupd.enable = true;

    gvfs.enable = true;
    udisks2.enable = true;
  };

  system.stateVersion = "24.05";
}
