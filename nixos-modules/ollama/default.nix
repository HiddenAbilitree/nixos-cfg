{
  config,
  lib,
  ...
}:
lib.mkIf config.ollama.enable {
  services.ollama = {
    enable = true;
    acceleration = "rocm";
  };
}
