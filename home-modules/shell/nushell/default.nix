{
  lib,
  pkgs,
  proot,
  root,
  nroot,
  froot,
  config,
  osConfig,
  ...
}: {
  config = {
    programs.nushell = {
      inherit (config.shell.nushell) enable;
      configFile.source = ./config.nu;
      settings = {
        show_banner = false;
        completions = {
          case_sensitive = false;
          quick = true;
          partial = true;
          algorithm = "fuzzy";
          external = {
            enable = true;
            max_results = 200;
          };
        };
      };
      # plugins = [pkgs.nushellPlugins.semver];
      shellAliases = {
        cfg = "xvim ${root}";
        pcfg = "xvim ${proot}";
        ncfg = "xvim ${nroot}";
        fcfg = "xvim ${froot}";

        secrets = "sops ${proot}/nixos/sops/secrets.yaml";

        nt = "git -C ${root} add -A and nh os test ${root} -H ${osConfig.networking.hostName} -v -- --accept-flake-config --show-trace";
        ns = "git -C ${root} add -A and nh os switch ${root} -H ${osConfig.networking.hostName} -v -- --accept-flake-config --show-trace";
        nc = "nh clean all";
        nr = "nixos-rebuild switch --flake ${root} --rollback --use-remote-sudo";
        nu = "nix flake update --flake ${root}";
        nus = "nu and ns";
        nfu = "nix flake update";

        # fetch = "fastfetch\nsource /etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh";

        cd = "z";

        gh = "GITHUB_TOKEN=$(open --raw ${osConfig.sops.secrets.github-token.path}) gh";

        code = "codium";

        q = "qalc";
        b = "bluetuith";
        # lg = "lazygit";

        # vpn = "cat ${osConfig.sops.secrets.zeuspwd.path} | sudo openconnect --protocol=anyconnect --user=ezhang7 --authgroup=STUDENT --useragent='AnyConnect*' --passwd-on-stdin vpn.gmu.edu";
        vpn = "cat ${osConfig.sops.secrets.zeuspwd.path} | sudo openconnect --background --user=ezhang7 --authgroup=STUDENT --passwd-on-stdin vpn.gmu.edu > /dev/null";
      };
    };
    shell.carapace.enable = lib.mkForce true;
  };
}
