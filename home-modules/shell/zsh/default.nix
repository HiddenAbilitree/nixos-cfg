{
  config,
  lib,
  nroot,
  osConfig,
  pkgs,
  proot,
  root,
  ...
}: {
  options.shell.zsh.enable = lib.mkEnableOption "zsh";

  config = lib.mkIf config.shell.zsh.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      autocd = true;
      initContent = builtins.readFile ./initContent.sh;
      dotDir = "${config.xdg.configHome}/zsh";
      shellAliases =
        {
          cfg = "xvim ${root}";
          pcfg = "xvim ${proot}";
          ncfg = "xvim ${nroot}";

          secrets = "sops ${proot}/nixos/sops/secrets.yaml";

          nc = "nh clean all";
          nu = "nix flake update --flake ${root}";
          nus = "nu && ns";
          nfu = "nix flake update";

          fetch = "fastfetch\nsource /etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh";

          cd = "z";
          ls = "eza";

          edit = "$EDITOR";

          q = "qalc";
          lg = "lazygit";
        }
        // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
          nt = "git -C ${root} add -A && nh os test ${root} -H ${osConfig.networking.hostName} -v -- --accept-flake-config --show-trace && source ~/.config/zsh/.zshrc";
          ns = "git -C ${root} add -A && nh os switch ${root} -H ${osConfig.networking.hostName} -v -- --accept-flake-config --show-trace && source ~/.config/zsh/.zshrc";
          nr = "nixos-rebuild switch --flake ${root} --rollback --use-remote-sudo";
          gh = "GITHUB_TOKEN=$(cat ${osConfig.sops.secrets.github-token.path}) gh";
          code = "codium";
          pdf = "nohup zathura $(fzf)";
          b = "bluetuith";
          vpn = "cat ${osConfig.sops.secrets.zeuspwd.path} | sudo openconnect --background --user=ezhang7 --authgroup=STUDENT --passwd-on-stdin vpn.gmu.edu > /dev/null";
        }
        // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
          nt = "git -C ${root} add -A && nh darwin build ${root} -H ${osConfig.networking.hostName} && source ~/.config/zsh/.zshrc";
          ns = "git -C ${root} add -A && nh darwin switch ${root} -H ${osConfig.networking.hostName} && source ~/.config/zsh/.zshrc";
          code = "zed";
        };
      plugins = [
        {
          name = "zsh-you-should-use";
          src = pkgs.fetchFromGitHub {
            owner = "MichaelAquilina";
            repo = "zsh-you-should-use";
            rev = "f13d39a1ae84219e4ee14e77d31bb774c91f2fe3";
            sha256 = "sha256-+3iAmWXSsc4OhFZqAMTwOL7AAHBp5ZtGGtvqCnEOYc0=";
          };
        }
      ];
      oh-my-zsh = {
        enable = true;
        plugins = [
          "bun"
          "git"
          "fzf"
          "docker"
          "docker-compose"
        ];
      };
    };
  };
}
