{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.server.ssh.enable {
    services = {
      fail2ban.enable = config.server.ssh.fail2ban.enable;
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
        };
      };
    };
  };
}
