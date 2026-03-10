{
  config,
  lib,
  ...
}: {
  options.ollama.enable = lib.mkEnableOption "ollama";

  config = lib.mkIf config.ollama.enable {
    services.ollama = {
      enable = true;
      openFirewall = true;
      host = "0.0.0.0";
    };
  };
}
