{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf config.desktop.services.mouse.enable {
  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "pulsar-udev";
      text = ''
        # Pulsar 8K Dongle
        SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3710", ATTRS{idProduct}=="5406", TAG+="uaccess"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="3710", ATTRS{idProduct}=="5406", TAG+="uaccess"

        # Pulsar 8K Dongle (secondary interface)
        SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3554", ATTRS{idProduct}=="f40a", TAG+="uaccess"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="3554", ATTRS{idProduct}=="f40a", TAG+="uaccess"
      '';
      destination = "/etc/udev/rules.d/70-pulsar.rules";
    })
  ];
}
