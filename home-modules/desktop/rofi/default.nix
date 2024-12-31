{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.rofi = lib.mkIf config.desktop.rofi.enable {
    enable = true;
    terminal = "${pkgs.kitty}/bin/kitty";
    font = "JetBrainsMono Nerd Font 12";
    package = pkgs.rofi-wayland;
    theme = ./theme.rasi;
    extraConfig = {
      kb-mode-next = "Right,Control+Tab";
      kb-mode-previous = "Left,Shift+Control+Tab";
      kb-move-char-forward = "Control+f";
      kb-move-char-back = "Control+b";
    };
  };
  home.file.".config/rofi/theme.rasi".text = builtins.readFile ./theme.rasi;
  home.file.".config/rofi/colors/tokyo-night.rasi".text = builtins.readFile ./colors/tokyo-night.rasi;
}
