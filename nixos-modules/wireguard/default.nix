{lib, ...}: {
  imports = [./client.nix ./server.nix];

  options = {
    wireguard = {
      listenPort = lib.mkOption {
        type = lib.types.int;
        description = "Port to listen on for wireguard";
        default = 51820;
      };

      server.enable = lib.mkEnableOption "wireguard server";

      client = {
        enable = lib.mkEnableOption "wireguard client";

        PrivateKeyFile = lib.mkOption {
          type = lib.types.str;
          description = "Path to the client's wireguard private key file";
        };

        address = lib.mkOption {
          type = lib.types.str;
          description = "Wireguard client address space";
        };
      };
    };
  };
}
