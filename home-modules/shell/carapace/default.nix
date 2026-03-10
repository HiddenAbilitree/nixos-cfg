{
  config,
  lib,
  ...
}: {
  options.shell.carapace.enable = lib.mkEnableOption "carapace";

  config = lib.mkIf config.shell.carapace.enable {
    programs.carapace = {
      enable = true;
      enableNushellIntegration = true;
    };
  };
}
