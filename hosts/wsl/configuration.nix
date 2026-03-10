{lib, ...}: {
  wsl = {
    enable = true;
    defaultUser = "ezhang";
  };

  ssh = {
    enable = true;
    fail2ban.enable = false;
  };

  programs.nix-ld.enable = true;

  system.stateVersion = lib.mkForce "24.11";
}
