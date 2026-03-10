{
  config,
  lib,
  ...
}: {
  options.ssh = {
    enable = lib.mkEnableOption "ssh";
    x11forwarding = lib.mkEnableOption "x11 forwarding";
    fail2ban.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable fail2ban.";
    };
  };

  config = lib.mkIf config.ssh.enable {
    services = {
      fail2ban.enable = config.ssh.fail2ban.enable;
      openssh = {
        enable = true;
        ports = [22];
        settings = {
          KbdInteractiveAuthentication = false;
          PasswordAuthentication = false;
          AllowUsers = [
            "ezhang"
            "root"
          ];
          UseDns = true;
          PermitRootLogin = "yes";
          X11Forwarding = config.ssh.x11forwarding;
        };
      };
    };
  };
}
