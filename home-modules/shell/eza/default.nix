{
  config,
  lib,
  ...
}: {
  options.shell.eza.enable = lib.mkEnableOption "eza";

  config = lib.mkIf config.shell.eza.enable {
    programs.eza = {
      enable = true;
      icons = "auto";
      colors = "always";
      enableZshIntegration = true;
      enableNushellIntegration = false;
    };
  };
}
