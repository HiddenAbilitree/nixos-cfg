{
  config,
  lib,
  ...
}: {
  imports = [
    ./docker.nix
    ./vm.nix
  ];

  options.virtualization.enable = lib.mkEnableOption "virtualization";

  config = lib.mkIf config.virtualization.enable {
    virtualization = {
      docker.enable = lib.mkDefault true;
      vm.enable = lib.mkDefault true;
    };
    virtualisation.waydroid.enable = true;
  };
}
