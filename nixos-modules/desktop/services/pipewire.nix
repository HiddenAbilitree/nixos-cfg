{
  lib,
  config,
  ...
}:
lib.mkIf config.desktop.services.pipewire.enable {
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  security.rtkit.enable = true;
}
