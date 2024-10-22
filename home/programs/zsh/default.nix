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
      nix-test = "git -C ~/nixos-cfg/ add -A && nh os test ~/nixos-cfg -H ${nixosConfig.networking.hostName} -v && source ~/.zshrc";
      nix-rebuild = "git -C ~/nixos-cfg/ add -A && git -C ~/nixos-cfg/ commit -a && git -C ~/nixos-cfg/ push; nh switch ~/nixos-cfg -H ${nixosConfig.networking.hostName} -v && source ~/.zshrc";
      nix-cleanup = "nh cleanup all";
      fetch = "fastfetch\nsource /etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh";
      cs367 = "cd ~/School/cs367";
      calq = "qalc";
      calc = "qalc";
      qalq = "qalc";
      calculator = "qalc";
      calculate = "qalc";
      nix-shell = "nix-shell --command \"zsh\"";
      nix-update = "sudo nix flake update /home/ezhang/nixos-cfg/";
      blue = "bluetuith";
      bluetooth = "bluetuith";
      lg = "lazygit";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "fzf"
        "thefuck"
      ];
    };
  };
}
