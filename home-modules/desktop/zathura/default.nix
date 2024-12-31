{
  config,
  lib,
  ...
}: {
  programs.zathura = lib.mkIf config.desktop.zathura.enable {
    enable = true;
    extraConfig = builtins.readFile ./.zathurarc;
  };
}
