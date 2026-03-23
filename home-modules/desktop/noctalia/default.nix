{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}: {
  options.desktop.noctalia.enable = lib.mkEnableOption "noctalia";

  config = lib.mkIf config.desktop.noctalia.enable {
    home.packages = [pkgs.quickshell];
    programs.noctalia-shell = {
      enable = true;
      systemd.enable = true;
      colors = removeAttrs (builtins.fromJSON (builtins.readFile ./tokyo-night-storm.json)).dark ["terminal"];
      settings = {
        settingsVersion = 57;
        dock.enabled = false;
        bar = {
          barType = "framed";
          density = "compact";
          position = "top";
          showCapsule = false;
          widgets = {
            left = [
              {
                id = "ControlCenter";
                useDistroLogo = true;
              }
              {
                hideUnoccupied = false;
                id = "Workspace";
                labelMode = "none";
              }
            ];
            center = [
            ];
            right =
              [
                {
                  id = "SystemMonitor";
                  compactMode = true;
                  iconColor = "none";
                  showCpuUsage = true;
                  showCpuCores = true;
                  showCpuFreq = false;
                  showCpuTemp = true;
                  showLoadAverage = false;
                  showMemoryUsage = true;
                  showMemoryAsPercent = false;
                  showSwapUsage = false;
                  showNetworkStats = false;
                  showDiskUsage = false;
                  showDiskUsageAsPercent = false;
                  showDiskAvailable = false;
                  diskPath = "/";
                }
                {
                  id = "Network";
                }
                {
                  formatHorizontal = "h:mm AP";
                  formatVertical = "h mm";
                  id = "Clock";
                  useMonospacedFont = true;
                  usePrimaryColor = true;
                }
              ]
              ++ (lib.optionals osConfig.laptop.enable [
                {
                  id = "Battery";
                }
                {id = "PowerProfile";}
              ]);
          };
        };
        general = {
          enableShadows = true;
          enableBlurBehind = true;
          shadowDirection = "center";
          radiusRatio = 0.2;
        };
        ui = {
          settingsPanelMode = "centered";
          translucentWidgets = true;
        };
        location = {
          monthBeforeDay = true;
          name = "New York, United States";
          useFahrenheit = true;
          use12hourFormat = true;
          hideWeatherCityName = true;
        };
      };
    };
  };
}
