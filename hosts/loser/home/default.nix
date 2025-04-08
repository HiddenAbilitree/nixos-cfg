{
  root,
  lib,
  osConfig,
  ...
}: {
  imports = [
    ./programs
  ];

  shell = {
    enable = true;
    zellij.autostart = false;
  };

  desktop = {
    enable = true;
    primary-monitor = "eDP-1";
    games = {
      roblox.enable = true;
      minecraft.enable = true;
    };
  };

  misc.enable = true;

  programs.zsh.shellAliases = {
    ns = lib.mkForce "git -C ${root} add -A && nh os switch ${root} -H ${osConfig.networking.hostName} -v -- -j0 --accept-flake-config --show-trace && source ~/.zshrc";
    nsl = lib.mkForce "git -C ${root} add -A && nh os switch ${root} -H ${osConfig.networking.hostName} -v -- --builders '' --accept-flake-config --show-trace && source ~/.zshrc";
  };
}
