{
  lib,
  config,
  ...
}: {
  systemd.sleep.extraConfig = lib.mkIf config.laptop.sleep.enable ''
    AllowSuspend=yes
    AllowHibernation=yes
    AllowHybridSleep=yes
    AllowSuspendThenHibernate=yes
  '';
}
