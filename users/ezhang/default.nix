{pkgs, ...}: {
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
    ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM0RksE+h4vQe1ig2wLUYcc3uxjxC43Zzq7Ki3TNNxVq eric@ericzhang.dev"
    ];
  };
}
