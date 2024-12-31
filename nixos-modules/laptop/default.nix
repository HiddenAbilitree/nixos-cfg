{
  lib,
  config,
  ...
}: {
  imports = [./fingerprint ./sleep ./hibernate.nix ./wifi];

  options.laptop = {
    enable = lib.mkEnableOption "laptop";
    fingerprint.enable = lib.mkEnableOption "fingerprint";
    hibernate.enable = lib.mkEnableOption "hibernation";
    sleep.enable = lib.mkEnableOption "sleep";
    wifi.enable = lib.mkEnableOption "wifi";
  };

  config.laptop = lib.mkIf config.laptop.enable {
    fingerprint.enable = lib.mkDefault true;
    hibernate.enable = lib.mkDefault true;
    sleep.enable = lib.mkDefault true;
    wifi.enable = lib.mkDefault true;
  };
}
