{
  config,
  lib,
  ...
}:
lib.mkIf config.distributed-builds.enable {
  home-manager.users.root.home.stateVersion = "24.05";
  nix =
    let
      builders = [
        {
          hostName = "winner";
          maxJobs = 15;
          speedFactor = 3;
          protocol = "ssh-ng";
          sshUser = "ezhang";
          sshKey = config.sops.secrets.personal-ssh-private.path;
          system = "x86_64-linux";
          supportedFeatures = [
            "big-parallel"
            "kvm"
            "nixos-test"
            "benchmark"
          ];
        }
        {
          hostName = "thething";
          maxJobs = 23;
          speedFactor = 3;
          protocol = "ssh-ng";
          sshUser = "ezhang";
          sshKey = config.sops.secrets.personal-ssh-private.path;
          system = "x86_64-linux";
          supportedFeatures = [
            "big-parallel"
            "kvm"
            "nixos-test"
            "benchmark"
          ];
        }
      ];
    in
    {
      buildMachines = lib.lists.filter (item: item.hostName != config.networking.hostName) builders;
      extraOptions = ''
        builders-use-substitutes = true
      '';
      distributedBuilds = true;
    };
}
