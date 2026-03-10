{config, ...}: {
  programs.zoxide = {
    inherit (config.shell.zoxide) enable;
    enableZshIntegration = true;
  };
}
