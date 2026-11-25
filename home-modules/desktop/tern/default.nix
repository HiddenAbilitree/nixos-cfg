{
  config,
  lib,
  packages-nix,
  system,
  ...
}:
let
  tern = packages-nix.packages.${system}.tern;
in
{
  options.desktop.tern.enable = lib.mkEnableOption "Tern";

  config = lib.mkIf config.desktop.tern.enable {
    home.packages = [ tern ];

    wayland.windowManager.hyprland.extraConfig = lib.mkIf config.desktop.hyprland.enable (
      lib.mkAfter ''
        hl.on("hyprland.start", function()
          hl.exec_cmd("${lib.getExe tern} daemon --login")
        end)
      ''
    );
  };
}
