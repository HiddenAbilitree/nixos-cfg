{
  config,
  lib,
  ...
}:
lib.mkIf config.desktop.services.pipewire.enable {
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    extraConfig.pipewire-pulse."99-block-source-volume"."pulse.rules" = [
      {
        matches = [
          { "application.process.binary" = "electron"; }
          { "application.process.binary" = "brave"; }
          { "application.process.binary" = "lunarclient"; }
        ];
        actions.quirks = [ "block-source-volume" ];
      }
    ];
  };

  security.rtkit.enable = true;
}
