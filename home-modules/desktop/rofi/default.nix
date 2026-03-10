{
  config,
  lib,
  pkgs,
  ...
}: {
  options.desktop.rofi.enable = lib.mkEnableOption "Rofi";

  config = lib.mkIf config.desktop.rofi.enable {
    programs.rofi = {
      enable = true;
      terminal = "${pkgs.kitty}/bin/kitty";
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
  };
}
