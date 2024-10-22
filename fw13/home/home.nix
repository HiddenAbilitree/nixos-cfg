{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./programs
    ./services
    ./scripts
    ../../home/home.nix
  ];
}
