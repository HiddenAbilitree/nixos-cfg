{config, ...}: {
  programs.atuin = {
    inherit (config.shell.atuin) enable;
    enableZshIntegration = true;
    settings = {
      auto_sync = true;
      sync_frequency = "5m";
      sync_address = "https://api.atuin.sh";
      update_check = false;
      style = "compact";
      search_mode = "prefix";
    };
  };
}
