{
  lib,
  config,
  ...
}: {
  imports = [./pipewire.nix ./keyboard.nix ./sunshine.nix ./ratbagd.nix];

  options.desktop.services = {
    enable = lib.mkEnableOption "desktop services";
    pipewire.enable = lib.mkEnableOption "Pipewire";
    keyboard.enable = lib.mkEnableOption "Keyboard udev options";
    sunshine.enable = lib.mkEnableOption "Sunshine";
    ratbagd.enable = lib.mkEnableOption "Ratbagd";
  };
  config = {
    desktop.services = lib.mkIf config.desktop.services.enable {
      pipewire.enable = lib.mkDefault true;
    };
  };
}
