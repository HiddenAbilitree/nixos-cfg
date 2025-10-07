{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf config.virtualization.vm.enable {
    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          swtpm.enable = true;
        };
      };
      spiceUSBRedirection.enable = true;
    };

    users.users.ezhang.extraGroups = ["libvirtd"];

    environment.systemPackages = with pkgs; [
      spice
      spice-gtk
      spice-protocol
      virt-viewer
      distrobox
      #virtio-win
      #win-spice
    ];
    programs.virt-manager.enable = true;

    home-manager.users.ezhang = {
      dconf.settings = {
        "org/virt-manager/virt-manager/connections" = {
          autoconnect = ["qemu:///system"];
          uris = ["qemu:///system"];
        };
      };
    };
  };
}
