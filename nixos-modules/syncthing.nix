{config, ...}: {
  services.syncthing = {
    inherit (config.syncthing) enable;
    group = "syncthing";
    user = "ezhang";
    dataDir = "/home/ezhang/";
    configDir = "/home/ezhang/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      devices = {
        "winner".id = "E67BUFQ-TSEDXMR-QMBHXYN-WVEG3GH-ITYUULF-LW3QKJR-J5YSPXS-YDWYHAI";
        "loser".id = "FFG3IMN-3L7FKJE-LEXRUKP-L4FKXI7-5QZSMKK-FYMXRFB-5PDKQ72-6OW5DAK";
        "thething".id = "LRTU3GO-IBACTED-WQB7NP7-3JRTWDZ-QFIVQHG-56IPFWX-QWGEK6B-NYQIUAJ";
      };
      folders = {
        "Documents" = {
          path = "/home/ezhang/Documents";
          devices = [
            "winner"
            "loser"
          ];
        };
        "Downloads" = {
          path = "/home/ezhang/Downloads";
          devices = [
            "winner"
            "loser"
          ];
        };
        "school" = {
          path = "/home/ezhang/school";
          devices = [
            "winner"
            "loser"
            "thething"
          ];
        };
        "prismlauncher" = {
          path = "/home/ezhang/.local/share/PrismLauncher/instances";
          devices = [
            "winner"
            "loser"
          ];
        };
      };
    };
  };
}
