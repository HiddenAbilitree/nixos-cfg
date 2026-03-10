{
  config,
  lib,
  ...
}: {
  options.shell.nh.enable = lib.mkEnableOption "nh";

  config = lib.mkIf config.shell.nh.enable {
    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 4d --keep 3 --nogcroots";
      };
    };
  };
}
