{
  config,
  lib,
  packages-nix,
  pkgs,
  system,
  ...
}:
let
  tern = packages-nix.packages.${system}.tern;
  settings = (pkgs.formats.json { }).generate "tern-settings.json" {
    theme = "Dark";
    theme_dark = "dark-tokyo-night-storm";
    font_family = "0xProto Nerd Font";
    font_size = 15;
    padding_x = 7;
    padding_y = 7;
    cursor = {
      shape = "bar";
      trail = "comet";
    };
    material = "Solid";
    unfocused_dim = 0;
    command_lenses = false;
  };
in
{
  options.desktop.tern.enable = lib.mkEnableOption "Tern";

  config = lib.mkIf config.desktop.tern.enable {
    home.packages = [ tern ];

    home.file.".omp/agent/themes/dark-tokyo-night-storm.json".source = ./dark-tokyo-night-storm.json;

    home.activation.ternSettings = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      (
        target=${lib.escapeShellArg "${config.xdg.configHome}/tern/settings.json"}
        state=${lib.escapeShellArg "${config.xdg.stateHome}/home-manager/tern-settings.json"}
        live=$target
        base=$state
        [[ -e $live ]] || live=/dev/null
        [[ -e $base ]] || base=/dev/null
        merged=$(${lib.getExe pkgs.jaq} --slurp --from-file ${../../merge-settings.jq} \
          --slurpfile base "$base" --slurpfile new ${settings} "$live")
        run install -D -m 644 /dev/stdin "$target" <<<"$merged"
        run install -D -m 644 ${settings} "$state"
      )
    '';

    wayland.windowManager.hyprland.extraConfig = lib.mkIf config.desktop.hyprland.enable (
      lib.mkAfter ''
        hl.on("hyprland.start", function()
          hl.exec_cmd("${lib.getExe tern} daemon --login")
        end)
      ''
    );
  };
}
