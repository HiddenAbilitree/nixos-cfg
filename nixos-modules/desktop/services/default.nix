{
  lib,
  config,
  ...
}: {
  imports = [./pipewire.nix ./keyboard.nix ./sunshine.nix];

  options.desktop.services = {
    enable = lib.mkEnableOption "desktop services";
    pipewire.enable = lib.mkEnableOption "Pipewire";
    keyboard.enable = lib.mkEnableOption "Keyboard udev options";
    sunshine.enable = lib.mkEnableOption "Sunshine";
  };
  config = {
    desktop.services = lib.mkIf config.desktop.services.enable {
      pipewire.enable = lib.mkDefault true;
    };
  };
}
