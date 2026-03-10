{
  config,
  lib,
  ...
}: {
  options.desktop.vicinae.enable = lib.mkEnableOption "Vicinae";

  config = lib.mkIf config.desktop.vicinae.enable {
    home.file = {
      ".config/vicinae/themes/tokyo-night-storm.json".source = ./tokyo-night-storm.json;
      ".config/vicinae/themes/tokyonight.png".source = ./tokyonight.png;
    };

    systemd.user.services.vicinae = {
      Service.Environment = lib.mkForce ["USE_LAYER_SHELL=0"];
      Service.EnvironmentFile = lib.mkForce [];
    };

    services.vicinae = {
      enable = true;
      systemd.autoStart = true;
      settings = {
        theme.name = "tokyo_night_storm.json";
        closeOnFocusLoss = false;
        faviconService = "twenty";
        font.size = 10;
        keybinding = "default";
        popToRootOnClose = false;
        rootSearch.searchFiles = false;
        window = {
          csd = true;
          opacity = 0.95;
          rounding = 10;
        };
      };
    };
  };
}
