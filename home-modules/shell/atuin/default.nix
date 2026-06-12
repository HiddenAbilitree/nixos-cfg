{
  config,
  lib,
  osConfig ? {},
  ...
}: let
  serverHost = "thething";
  serverPort = 18888;
  serverUrl =
    if (osConfig.networking.hostName or "") == serverHost
    then "http://127.0.0.1:${toString serverPort}"
    else "http://10.100.0.1:${toString serverPort}";
in {
  options.shell.atuin.enable = lib.mkEnableOption "Atuin";

  config = lib.mkIf config.shell.atuin.enable {
    programs.atuin = {
      enable = true;
      enableZshIntegration = false;
      settings = {
        auto_sync = true;
        sync_frequency = "5m";
        sync_address = serverUrl;
        update_check = false;
        style = "compact";
        search_mode = "prefix";
      };
    };
  };
}
