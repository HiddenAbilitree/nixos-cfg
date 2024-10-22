{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./programs
    ./services
    ../../home/home.nix
  ];
}
