{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf config.desktop.services.enable {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    udev.packages = [
      (pkgs.writeTextFile {
        name = "drunkdeer-udev";
        text = ''
          SUBSYSTEM=="hidraw", ATTRS{idVendor}=="352d", ATTRS{idProduct}=="2383", TAG+="uaccess"
          SUBSYSTEM=="usb", ATTRS{idVendor}=="352d", ATTRS{idProduct}=="2383", TAG+="uaccess"
        '';
        destination = "/etc/udev/rules.d/70-drunkdeer.rules";
      })
    ];
  };
  security.rtkit.enable = true;
}
