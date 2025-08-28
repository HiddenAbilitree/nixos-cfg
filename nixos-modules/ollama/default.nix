{ config, ... }:
{
  services.ollama = {
    inherit (config.ollama) enable;
    acceleration = "rocm";
  };
}
