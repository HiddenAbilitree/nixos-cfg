{
  pkgs,
  config,
  ...
}: {
  users.users.ezhang = {
    isNormalUser = true;
    description = "Eric Zhang";
    createHome = true;
    home = "/home/ezhang";
    ignoreShellProgramCheck = true;
    extraGroups = [
      "docker"
      "networkmanager"
      "sudo"
      "wheel"
      "openrazer"
      "wireshark"
      "inputs"
    ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKr7UGzh6MuEUXtP5Ij7cg3jkDVKx5w4aSkisXuMo5o6 me@ericzhang.dev"
    ];
  };
}
