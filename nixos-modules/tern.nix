{
  config,
  lib,
  packages-nix,
  pkgs,
  system,
  ...
}:
let
  tern = packages-nix.packages.${system}.tern;
  authorizedKeys = pkgs.writeText "ezhang-authorized-keys" (
    lib.concatLines config.users.users.ezhang.openssh.authorizedKeys.keys
  );
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
      users.users.ezhang.linger = true;

      home-manager.users.ezhang =
        { config, lib, ... }:
        {
          home.packages = [ tern ];
          systemd.user.services = {
            tern-remote = ternService "Tern remote sessions" "remote serve --user";
            tern-web = ternService "Tern web client" "web serve";
          };
          home.activation.ternAuthorizedKeys = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
            (
              target=${lib.escapeShellArg "${config.home.homeDirectory}/.ssh/authorized_keys"}
              state=${lib.escapeShellArg "${config.xdg.stateHome}/home-manager/tern-authorized-keys"}
              live=$target
              base=$state
              [[ -e $live ]] || live=/dev/null
              [[ -e $base ]] || base=/dev/null
              merged=$(grep -vxFf "$base" "$live"; cat ${authorizedKeys})
              run install -D -m 600 /dev/stdin "$target.hm.tmp" <<<"$merged"
              run mv -f "$target.hm.tmp" "$target"
              run install -D -m 644 ${authorizedKeys} "$state"
            )
          '';
        };
    })
  ];
}
