{
  lib,
  config,
  ...
}: {
  imports = [
    ./fw-fancontrol
    ./fingerprint
    ./sleep
    ./hibernate.nix
    ./wifi
  ];

  options.laptop = with lib;
  with lib.types; let
    defaultConfig = builtins.fromJSON (builtins.readFile ./fw-fancontrol/config.json);
  in {
    enable = mkEnableOption "laptop";
    fan = {
      enable = mkOption {
        type = bool;
        default = false;
        description = ''
          Enable fw-fanctrl systemd service and install the needed packages.
        '';
      };
      disableBatteryTempCheck = mkOption {
        type = bool;
        default = false;
        description = ''
          Disable checking battery temperature sensor
        '';
      };
      config = {
        defaultStrategy = mkOption {
          type = str;
          default = defaultConfig.defaultStrategy;
          description = "Default strategy to use";
        };
        strategyOnDischarging = mkOption {
          type = str;
          default = defaultConfig.strategyOnDischarging;
          description = "Default strategy on discharging";
        };
        strategies = mkOption {
          default = defaultConfig.strategies;
          type = attrsOf (submodule (
            {...}: {
              options = {
                fanSpeedUpdateFrequency = mkOption {
                  type = int;
                  default = 5;
                  description = "How often the fan speed should be updated in seconds";
                };
                movingAverageInterval = mkOption {
                  type = int;
                  default = 25;
                  description = "Interval (seconds) of the last temperatures to use to calculate the average temperature";
                };
                speedCurve = mkOption {
                  default = [];
                  description = "How should the speed curve look like";
                  type = listOf (submodule (
                    {...}: {
                      options = {
                        temp = mkOption {
                          type = int;
                          default = 0;
                          description = "Temperature at which the fan speed should be changed";
                        };
                        speed = mkOption {
                          type = int;
                          default = 0;
                          description = "Percent how fast the fan should run at";
                        };
                      };
                    }
                  ));
                };
              };
            }
          ));
        };
      };
    };
    fingerprint.enable = lib.mkEnableOption "fingerprint";
    hibernate.enable = lib.mkEnableOption "hibernation";
    sleep.enable = lib.mkEnableOption "sleep";
    wifi.enable = lib.mkEnableOption "wifi";
  };

  config.laptop = lib.mkIf config.laptop.enable {
    fan.enable = lib.mkDefault true;
    fingerprint.enable = lib.mkDefault true;
    hibernate.enable = lib.mkDefault false;
    sleep.enable = lib.mkDefault true;
    wifi.enable = lib.mkDefault true;
  };
}
