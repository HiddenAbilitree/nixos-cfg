{
  nixosConfig,
  config,
  pkgs,
  ...
}:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    initExtra = "fastfetch";
    shellAliases = {
      cfg = "code ~/nixos-cfg/";

      # nix aliases
      nix-test = "git -C ~/nixos-cfg/ add -A && nh os test ~/nixos-cfg -H ${nixosConfig.networking.hostName} -v && source ~/.zshrc";
      nix-rebuild = "git -C ~/nixos-cfg/ add -A && sh ~/nixos-cfg/home/programs/zsh/scripts/nix-commit.sh && git -C ~/nixos-cfg/ push && nh os switch ~/nixos-cfg -H ${nixosConfig.networking.hostName} -v  && source ~/.zshrc";
      nix-cleanup = "nh clean all";
      nix-shell = "nix-shell --command \"zsh\"";
      nix-update = "sudo nix flake update --flake /home/ezhang/nixos-cfg/";

      fetch = "fastfetch\nsource /etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh";

      cs367 = "cd ~/School/cs367";

      code = "codium";

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
        "git"
        "fzf"
        "thefuck"
      ];
    };
  };
}
