{pkgs, ...}: {
  boot = {
    supportedFilesystems.zfs = true;

    zfs = {
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
