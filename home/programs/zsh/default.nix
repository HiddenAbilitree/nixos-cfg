{
  nixosConfig,
  config,
  pkgs,
  root,
  ...
}:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    initExtra = builtins.readFile ./initExtra.sh;
    shellAliases = {
      cfg = "code ${root}";
      # nix aliases
      nix-test = "git -C ${root} add -A && nh os test ${root} -H ${nixosConfig.networking.hostName} -v -- --accept-flake-config && source ~/.zshrc";
      nix-rebuild = "git -C ${root} add -A && commit ${root} && git -C ${root} push && nh os switch ${root} -H ${nixosConfig.networking.hostName} -v -- --accept-flake-config && source ~/.zshrc";
      nix-cleanup = "nh clean all";
      zsh-shell = "nix-shell --command \"zsh\"";
      nix-update = "sudo nix flake update --flake ${root}";

      fetch = "fastfetch\nsource /etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh";

      c-367 = "nix-shell ~/School/cs367/shell.nix";

      code = "codium";

      cat = "ccat";

      calq = "qalc";
      calc = "qalc";
      qalq = "qalc";
      calculator = "qalc";
      calculate = "qalc";

      blue = "bluetuith";
      bluetooth = "bluetuith";
      blu = "bluetuith";

      lg = "lazygit";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "bun"
        "colorize"
        "git"
        "fzf"
        "thefuck"
      ];
    };
  };
}
