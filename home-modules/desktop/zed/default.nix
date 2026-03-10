{
  config,
  lib,
  pkgs,
  ...
}: {
  options.desktop.zed.enable = lib.mkEnableOption "Zed Editor";

  config = lib.mkIf config.desktop.zed.enable {
    programs.zed-editor = {
      enable = true;
      extensions = [
        "tokyo-night"
        "nix"
        "oxlint"
      ];
      userSettings = {
        buffer_font_family = "0xProto Nerd Font";
        buffer_font_weight = 600;
        buffer_font_size = 14;
        telemetry = {
          metrics = false;
        };
        vim_mode = true;
        vim = {
          toggle_relative_line_numbers = true;
        };
        languages = {
          JavaScript = {
            code_actions_on_format = {
              "source.fixAll.eslint" = true;
            };
          };
        };
      };
      userKeymaps = [
        {
          context = "Editor && vim_mode == normal && ! menu";
          bindings = {
            "space f f" = "file_finder::Toggle";
            "space f g" = "workspace::NewSearch";
            "ctrl-k" = "vim::ScrollUp";
            "shift-k" = "vim::ScrollUp";
            "ctrl-j" = "vim::ScrollDown";
          };
        }
        {
          context = "(VimControl && !menu)";
          bindings = {
            "space c d" = "editor::Hover";
          };
        }
        {
          context = "Terminal";
          bindings = {
            "ctrl-w" = "pane::CloseActiveItem";
          };
        }
        {
          context = "Workspace";
          bindings = {
            ctrl-tab = "pane::ActivateNextItem";
            ctrl-shift-tab = "pane::ActivatePreviousItem";
            ctrl-w = "pane::CloseActiveItem";
          };
        }
      ];
    };
  };
}
