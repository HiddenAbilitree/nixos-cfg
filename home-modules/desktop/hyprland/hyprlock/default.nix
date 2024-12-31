{
  config,
  lib,
  ...
}: {
  programs.hyprlock = lib.mkIf config.desktop.hyprland.hyprlock.enable {
    enable = true;
    # settings = {
    #   enable_fingerprint = true;
    #   hide_cursor = true;
    # };
    extraConfig = builtins.readFile ./hyprlock.conf;
  };
}
