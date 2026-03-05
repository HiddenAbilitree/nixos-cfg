{
  lib,
  config,
  ...
}: {
  systemd.sleep.settings.Sleep = lib.mkIf config.laptop.sleep.enable {
    AllowSuspend = true;
    AllowHibernation = true;
    AllowHybridSleep = true;
    AllowSuspendThenHibernate = true;
  };
}
