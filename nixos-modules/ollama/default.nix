{config, ...}: {
  services.ollama = {
    inherit (config.ollama) enable;
    openFirewall = true;
    host = "0.0.0.0";
  };
}
