{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    duf
    fd
    fzf
    jq
    killall
    p7zip
    ripgrep
    sops
    unzip
    wget
    zip
  ];

  nix = {
    optimise.automatic = true;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "ezhang"
      ];
    };
  };

  programs.zsh.enable = true;

  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    primaryUser = "ezhang";
    stateVersion = 6;
  };

  users.users.ezhang = {
    home = "/Users/ezhang";
    shell = pkgs.zsh;
  };
}
