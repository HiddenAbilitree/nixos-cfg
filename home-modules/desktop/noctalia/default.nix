{
  lib,
  config,
  ...
}:
lib.mkIf config.desktop.noctalia.enable {
  programs.noctalia-shell = {
    enable = true;
    settings = {
      bar = {
        density = "compact";
        position = "right";
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
          right = [
            {
              id = "System Monitor";
              compactMode = true;
              iconColor = "none";
              showCpuUsage = true;
              showCpuCores = false;
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
          ];
        };
      };
      colorSchemes.predefinedScheme = "Monochrome";
      general = {
        radiusRatio = 0.2;
      };
      location = {
        monthBeforeDay = true;
        name = "New York, United States";
      };
    };
  };
}
