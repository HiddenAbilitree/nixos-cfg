{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    <nixos-wsl/modules>
  ];

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  system.stateVersion = "24.11";
}
