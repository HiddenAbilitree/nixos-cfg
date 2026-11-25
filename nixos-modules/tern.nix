{
  config,
  lib,
  packages-nix,
  system,
  ...
}:
let
  tern = packages-nix.packages.${system}.tern;
  ternService = description: arguments: {
    Unit = {
      Description = description;
      Documentation = "https://stencil.so";
      StartLimitIntervalSec = 60;
      StartLimitBurst = 10;
    };
    Service = {
      Type = "exec";
      ExecStart = "${lib.getExe tern} ${arguments}";
      Restart = "on-failure";
      RestartSec = 2;
      RestartPreventExitStatus = 2;
      KillMode = "process";
      TimeoutStopSec = 10;
    };
    Install.WantedBy = [ "default.target" ];
  };
in
{
  options.tern.server.enable = lib.mkEnableOption "Tern's remote and web servers for ezhang";

  config = lib.mkMerge [
    (lib.mkIf (config.tern.server.enable || config.home-manager.users.ezhang.desktop.tern.enable) {
      system.extraDependencies = [ tern.src ];
    })
    (lib.mkIf config.tern.server.enable {
      assertions = [
        {
          assertion = config.services.openssh.enable;
          message = "tern.server authorizes the SSH keys in /etc/ssh/authorized_keys.d/ezhang, which only exists with services.openssh enabled";
        }
      ];

      users.users.ezhang.linger = true;

      home-manager.users.ezhang = {
        home.packages = [ tern ];
        systemd.user.services = {
          tern-remote = ternService "Tern remote sessions" "remote serve --user --authorized-keys /etc/ssh/authorized_keys.d/ezhang";
          tern-web = ternService "Tern web client" "web serve";
        };
      };
    })
  ];
}
