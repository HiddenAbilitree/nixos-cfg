{
  pkgs,
  proot,
  root,
  nroot,
  config,
  osConfig,
  lib,
  ...
}: {
  programs.zsh = lib.mkIf config.shell.zsh.enable {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    initExtraFirst = ''
      export GITHUB_TOKEN="$(cat ${osConfig.sops.secrets.github-token.path})"
      export GH_TOKEN="$GITHUB_TOKEN"
    '';
    initExtra = builtins.readFile ./initExtra.sh;
    shellAliases = {
      cfg = "xvim ${root}";
      pcfg = "xvim ${proot}";
      ncfg = "xvim ${nroot}";

      secrets = "sops ${proot}/nixos/sops/secrets.yaml";

      nt = "git -C ${root} add -A && nh os test ${root} -H ${osConfig.networking.hostName} -v -- --accept-flake-config --show-trace && source ~/.zshrc";
      ns = "git -C ${root} add -A && nh os switch ${root} -H ${osConfig.networking.hostName} -v -- --accept-flake-config --show-trace && source ~/.zshrc";
      nc = "nh clean all";
      nr = "nixos-rebuild switch --flake ${root} --rollback --use-remote-sudo";
      nu = "nix flake update --flake ${root}";
      nus = "nu && ns";
      nfu = "nix flake update";

      fetch = "fastfetch\nsource /etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh";

      cd = "z";
      ls = "eza";

      edit = "$EDITOR";
      code = "codium";

      pdf = "nohup zathura $(fzf)";

      q = "qalc";
      b = "bluetuith";
      lg = "lazygit";

      # vpn = "cat ${osConfig.sops.secrets.zeuspwd.path} | sudo openconnect --protocol=anyconnect --user=ezhang7 --authgroup=STUDENT --useragent='AnyConnect*' --passwd-on-stdin vpn.gmu.edu";
      vpn = "cat ${osConfig.sops.secrets.zeuspwd.path} | sudo openconnect --background --user=ezhang7 --authgroup=STUDENT --passwd-on-stdin vpn.gmu.edu";
    };
    plugins = [
      # {
      #   name = "fzf-tab";
      #   src = pkgs.zsh-fzf-tab;
      #   file = "share/fzf-tab/fzf-tab.plugin.zsh";
      # }
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
        "tmux"
      ];
    };
  };
}
