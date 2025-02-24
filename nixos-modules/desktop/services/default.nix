{
  lib,
  config,
  ...
}: {
  imports = [./pipewire.nix ./drunkdeer.nix ./sunshine.nix];

  options.desktop.services = {
    enable = lib.mkEnableOption "desktop services";
    pipewire.enable = lib.mkEnableOption "Pipewire";
    drunkdeer.enable = lib.mkEnableOption "Drunkdeer udev options";
    sunshine.enable = lib.mkEnableOption "Sunshine";
  };
  config = {
    desktop.services = lib.mkIf config.desktop.services.enable {
      pipewire.enable = lib.mkDefault true;
    };
  };
}
