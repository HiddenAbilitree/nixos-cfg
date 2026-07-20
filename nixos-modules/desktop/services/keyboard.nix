{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.desktop.services.keyboard.enable {
  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "drunkdeer-udev";
      text = ''
        SUBSYSTEM=="hidraw", ATTRS{idVendor}=="352d", ATTRS{idProduct}=="2383", TAG+="uaccess"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="352d", ATTRS{idProduct}=="2383", TAG+="uaccess"
      '';
      destination = "/etc/udev/rules.d/70-drunkdeer.rules";
    })
    (pkgs.writeTextFile {
      name = "wooting-udev";
      text = ''
        SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff01", TAG+="uaccess"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff01", TAG+="uaccess"

        SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2402", TAG+="uaccess"

        SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff02", TAG+="uaccess"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff02", TAG+="uaccess"

        SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2403", TAG+="uaccess"

        SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", TAG+="uaccess"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="31e3", TAG+="uaccess"
      '';
      destination = "/etc/udev/rules.d/70-wooting.rules";
    })
  ];
}
