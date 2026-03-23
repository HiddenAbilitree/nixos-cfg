{
  config,
  lib,
  ...
}: {
  imports = [
    ./fw-fancontrol
    ./fingerprint
    ./sleep
    ./hibernate.nix
    ./wifi
  ];

  options.laptop = let
    defaultConfig = builtins.fromJSON (builtins.readFile ./fw-fancontrol/config.json);
  in {
    enable = lib.mkEnableOption "laptop";
    fan = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable fw-fanctrl systemd service and install the needed packages.";
      };
      disableBatteryTempCheck = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Disable checking battery temperature sensor";
      };
      config = {
        defaultStrategy = lib.mkOption {
          type = lib.types.str;
          default = defaultConfig.defaultStrategy;
          description = "Default strategy to use";
        };
        strategyOnDischarging = lib.mkOption {
          type = lib.types.str;
          default = defaultConfig.strategyOnDischarging;
          description = "Default strategy on discharging";
        };
        strategies = lib.mkOption {
          default = defaultConfig.strategies;
          type = lib.types.attrsOf (
            lib.types.submodule (_: {
              options = {
                fanSpeedUpdateFrequency = lib.mkOption {
                  type = lib.types.int;
                  default = 5;
                  description = "How often the fan speed should be updated in seconds";
                };
                movingAverageInterval = lib.mkOption {
                  type = lib.types.int;
                  default = 25;
                  description = "Interval (seconds) of the last temperatures to use to calculate the average temperature";
                };
                speedCurve = lib.mkOption {
                  default = [];
                  description = "How should the speed curve look like";
                  type = lib.types.listOf (
                    lib.types.submodule (_: {
                      options = {
                        temp = lib.mkOption {
                          type = lib.types.int;
                          default = 0;
                          description = "Temperature at which the fan speed should be changed";
                        };
                        speed = lib.mkOption {
                          type = lib.types.int;
                          default = 0;
                          description = "Percent how fast the fan should run at";
                        };
                      };
                    })
                  );
                };
              };
            })
          );
        };
      };
    };
    fingerprint.enable = lib.mkEnableOption "fingerprint";
    hibernate.enable = lib.mkEnableOption "hibernation";
    sleep.enable = lib.mkEnableOption "sleep";
    wifi.enable = lib.mkEnableOption "wifi";
  };

  config = lib.mkIf config.laptop.enable {
    laptop = {
      fan.enable = lib.mkDefault true;
      fingerprint.enable = lib.mkDefault true;
      hibernate.enable = lib.mkDefault false;
      sleep.enable = lib.mkDefault true;
      wifi.enable = lib.mkDefault true;
    };
    services.upower.enable = true;
  };
}
