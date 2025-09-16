{
  config,
  pkgs,
  ...
}: {
  programs.rofi = {
    inherit (config.desktop.rofi) enable;
    terminal = "${pkgs.kitty}/bin/kitty";
    # font = "JetBrainsMono Nerd Font 12";
    font = "0xProto Nerd Font 12";
    package = pkgs.rofi;
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
