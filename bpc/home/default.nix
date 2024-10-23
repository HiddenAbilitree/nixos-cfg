{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./programs
    ./services
    ../../home
  ];
}
