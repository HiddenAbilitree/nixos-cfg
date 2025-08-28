{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.ssh.enable {
    services = {
      fail2ban.enable = config.ssh.fail2ban.enable;
      openssh = {
        enable = true;
        ports = [ 22 ];
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
