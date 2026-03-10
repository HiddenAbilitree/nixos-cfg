{
  config,
  lib,
  ...
}: {
  options.mongodb.enable = lib.mkEnableOption "mongodb";

  config = lib.mkIf config.mongodb.enable {
    services.mongodb.enable = true;
  };
}
