{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.types; let
  cfg = config.laptop.fan;
  fw-fanctrl = pkgs.fw-fanctrl;
in {
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      fw-fanctrl
      fw-ectool
    ];

    environment.etc."fw-fanctrl/config.json" = {
      text = builtins.toJSON cfg.config;
    };

    systemd.services.fw-fanctrl = {
      description = "Framework Fan Controller";
      after = ["multi-user.target"];
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        ExecStart = "${fw-fanctrl}/bin/fw-fanctrl --output-format \"JSON\" run --config \"/etc/fw-fanctrl/config.json\" --silent ${lib.strings.optionalString cfg.disableBatteryTempCheck "--no-battery-sensors"}";
        ExecStopPost = "${pkgs.fw-ectool}/bin/ectool autofanctrl";
      };
      enable = true;
      wantedBy = ["multi-user.target"];
    };

    environment.etc."systemd/system-sleep/fw-fanctrl-suspend.sh".source = pkgs.writeShellScript "fw-fanctrl-suspend" (
      builtins.replaceStrings [''/usr/bin/python3 "%PREFIX_DIRECTORY%/bin/fw-fanctrl"'' "/bin/bash"] ["${fw-fanctrl}/bin/fw-fanctrl" ""] (
        builtins.readFile ./fw-fanctrl-suspend
      )
    );
  };
}
