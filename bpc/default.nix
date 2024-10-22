{
  imports = [ ./hardware-configuration.nix ];
  home-manager.users.ezhang = import ./home;
  networking.hostName = "winner";
}
