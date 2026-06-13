{pkgs, ...}: {
  boot = {
    supportedFilesystems.zfs = true;

    zfs = {
      # thething boots from btrfs. Keep ZFS as an imported data pool and avoid
      # force-import behavior that could make boot recovery harder after an
      # unclean shutdown or a pool/device mismatch.
      forceImportRoot = false;
      forceImportAll = false;
      devNodes = "/dev/disk/by-id";
    };
  };

  environment.systemPackages = [pkgs.zfs];

  services.zfs = {
    autoScrub = {
      enable = true;
      pools = ["thepool"];
    };
    trim.enable = true;
  };
}
