{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.virtualization.vm.enable = lib.mkEnableOption "vm";

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

    users.users.ezhang.extraGroups = [ "libvirtd" ];
    systemd.services.libvirt-default-network = {
      after = [ "libvirtd.service" ];
      requires = [ "libvirtd.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        ${pkgs.libvirt}/bin/virsh net-autostart default >/dev/null 2>&1 || true
        ${pkgs.libvirt}/bin/virsh net-start default >/dev/null 2>&1 || true
      '';
    };

    environment.systemPackages = with pkgs; [
      spice
      spice-gtk
      spice-protocol
      virt-viewer
      distrobox
    ];
    programs.virt-manager.enable = true;

    home-manager.users.ezhang = {
      dconf.settings = {
        "org/virt-manager/virt-manager/connections" = {
          autoconnect = [ "qemu:///system" ];
          uris = [ "qemu:///system" ];
        };
      };
    };
  };
}
