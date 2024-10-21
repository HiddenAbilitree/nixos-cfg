{
  config,
  pkgs,
  ...
}:
{
  programs.git.signing = {
    key = "503DEDEE1AC71158";
    signByDefault = true;
  };
}
