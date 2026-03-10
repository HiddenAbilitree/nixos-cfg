{
  config,
  lib,
  ...
}: {
  options.shell.zoxide.enable = lib.mkEnableOption "Zoxide";

  config = lib.mkIf config.shell.zoxide.enable {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
