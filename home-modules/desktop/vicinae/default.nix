{config, ...}: {
  home.file = {
    ".config/vicinae/themes/tokyo-night-storm.json" = {
      inherit (config.desktop.vicinae) enable;
      source = ./tokyo-night-storm.json;
    };
    ".config/vicinae/themes/tokyonight.png" = {
      inherit (config.desktop.vicinae) enable;
      source = ./tokyonight.png;
    };
  };
  services.vicinae = {
    inherit (config.desktop.vicinae) enable;
    autoStart = true;
    settings = {
      theme.name = "tokyo-night-storm.json";
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
}
