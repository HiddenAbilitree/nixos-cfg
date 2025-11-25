{config, ...}: {
  services.ollama = {
    inherit (config.ollama) enable;
    acceleration = "rocm";
    openFirewall = true;
    host = "0.0.0.0";
  };
}
