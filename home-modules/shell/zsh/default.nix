{
  pkgs,
  proot,
  root,
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
      secrets = "sops ${proot}/home/sops/secrets.yaml";

      nix-commit = "git -C ${root} add -A && commit ${root} && git -C ${root} push";
      nix-develop = "nix develop -c zsh";
      nix-test = "git -C ${root} add -A && nh os test ${root} -H ${osConfig.networking.hostName} -v -- --accept-flake-config --show-trace && source ~/.zshrc";
      nix-switch = "git -C ${root} add -A && nh os switch ${root} -H ${osConfig.networking.hostName} -- --accept-flake-config --quiet && source ~/.zshrc";
      nix-cleanup = "nh clean all";
      nix-rollback = "nixos-rebuild switch --flake ${root} --rollback";
      nix-update = "nix flake update --flake ${root}";
      nix-pull = "git -C ${root} pull";

      fetch = "fastfetch\nsource /etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh";

      cd = "z";
      ls = "eza";

      edit = "$EDITOR";
      code = "codium";

      pdf = "nohup zathura $(fzf)";

      q = "qalc";
      b = "bluetuith";
      lg = "lazygit";

      vpn = "cat ${osConfig.sops.secrets.zeuspwd.path} | sudo openconnect --protocol=anyconnect --user=ezhang7 --usergroup=STUDENT --useragent='AnyConnect*' --passwd-on-stdin vpn.gmu.edu";
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
      ];
    };
  };
}
