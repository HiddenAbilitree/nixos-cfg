{
  config,
  lib,
  ...
}: {
  nix = lib.mkIf config.distributed-builds.enable {
    buildMachines = [
      {
        hostName = "winner";
        maxJobs = 15;
        speedFactor = 2;
        protocol = "ssh-ng";
        sshUser = "ezhang";
        sshKey = config.sops.secrets.personal-ssh-private.path;
        system = "x86_64-linux";
      }
      {
        hostName = "thething";
        maxJobs = 23;
        speedFactor = 3;
        protocol = "ssh-ng";
        sshUser = "ezhang";
        sshKey = config.sops.secrets.personal-ssh-private.path;
        system = "x86_64-linux";
      }
    ];
    extraOptions = ''
      builders-use-substitutes = true
    '';
    distributedBuilds = true;
  };
}
