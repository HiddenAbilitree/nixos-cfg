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
      nix-test = "git -C ~/nixos-cfg/ add -A && sudo nixos-rebuild test --flake ~/nixos-cfg/#${nixosConfig.networking.hostName} && source ~/.zshrc";
      nix-rebuild = "git -C ~/nixos-cfg/ add -A && git -C ~/nixos-cfg/ commit -a; sudo nixos-rebuild test --flake ~/nixos-cfg/#${nixosConfig.networking.hostName} && source ~/.zshrc";
      nix-clear = "sudo nix-collect-garbage -d; sudo /run/current-system/bin/switch-to-configuration boot";
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
