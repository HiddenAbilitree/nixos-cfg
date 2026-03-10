{
  config,
  lib,
  ...
}: {
  options.desktop.zathura.enable = lib.mkEnableOption "Zathura";

  config = lib.mkIf config.desktop.zathura.enable {
    programs.zathura = {
      enable = true;
      extraConfig = builtins.readFile ./.zathurarc;
    };
  };
}
