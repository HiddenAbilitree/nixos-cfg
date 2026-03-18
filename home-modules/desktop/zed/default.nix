{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}: {
  options.desktop.zed.enable = lib.mkEnableOption "Zed Editor";

  config = lib.mkIf config.desktop.zed.enable {
    programs.zed-editor = {
      enable = true;

      package = pkgs.symlinkJoin {
        name = "zed-editor-with-secrets";
        paths = [pkgs.zed-editor];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/zeditor \
            --run 'export Z_AI_API_KEY="$(cat ${osConfig.sops.secrets.z-ai-api-key.path})"'
        '';
      };

      extraPackages = with pkgs; [
        alejandra
        shfmt
        nixd
      ];

      mutableUserKeymaps = false;

      extensions = [
        "astro"
        "basher"
        "haskell"
        "java"
        "latex"
        "lua"
        "nix"
        "nu"
        "oxlint"
        "ruff"
        "tokyo-night"
        "tsgo"
        "toml"
        "typst"
      ];

      userSettings = {
        theme = "Tokyo Night Storm";
        buffer_font_family = "0xProto Nerd Font";
        buffer_font_weight = 600;
        buffer_font_size = 14;
        tab_size = 2;
        soft_wrap = "none";
        format_on_save = "on";
        show_whitespaces = "boundary";

        vim_mode = true;
        vim = {
          toggle_relative_line_numbers = true;
          use_smartcase_find = true;
          use_system_clipboard = "always";
        };

        agent = {
          tool_permissions = {
            default = "allow";
          };
        };

        language_models = {
          openai_compatible = {
            "Z.ai" = {
              api_url = "https://api.z.ai/api/coding/paas/v4";
              available_models = [
                {
                  name = "glm-4.5";
                  display_name = "GLM-4.5";
                  max_tokens = 128000;
                  max_output_tokens = 98304;
                  max_completion_tokens = 98304;
                  capabilities = {
                    tools = true;
                    images = false;
                    parallel_tool_calls = true;
                    prompt_cache_key = true;
                  };
                }
                {
                  name = "glm-4.6";
                  display_name = "GLM-4.6";
                  max_tokens = 200000;
                  max_output_tokens = 131072;
                  max_completion_tokens = 131072;
                  capabilities = {
                    tools = true;
                    images = false;
                    parallel_tool_calls = true;
                    prompt_cache_key = true;
                  };
                }
                {
                  name = "glm-4.7";
                  display_name = "GLM-4.7";
                  max_tokens = 200000;
                  max_output_tokens = 128000;
                  max_completion_tokens = 128000;
                  capabilities = {
                    tools = true;
                    images = false;
                    parallel_tool_calls = true;
                    prompt_cache_key = true;
                  };
                }
                {
                  name = "glm-4.7-flash";
                  display_name = "GLM-4.7 Flash";
                  max_tokens = 200000;
                  max_output_tokens = 128000;
                  max_completion_tokens = 128000;
                  capabilities = {
                    tools = true;
                    images = false;
                    parallel_tool_calls = true;
                    prompt_cache_key = true;
                  };
                }
                {
                  name = "glm-4.7-flashx";
                  display_name = "GLM-4.7 FlashX";
                  max_tokens = 200000;
                  max_output_tokens = 128000;
                  max_completion_tokens = 128000;
                  capabilities = {
                    tools = true;
                    images = false;
                    parallel_tool_calls = true;
                    prompt_cache_key = true;
                  };
                }
              ];
            };
          };
        };

        telemetry = {
          metrics = false;
          diagnostics = false;
        };

        git = {
          git_gutter = "tracked_files";
          inline_blame = {
            enabled = true;
          };
        };

        inlay_hints = {
          enabled = false;
        };

        indent_guides = {
          enabled = true;
        };

        scrollbar = {
          show = "auto";
          git_diff = true;
          diagnostics = "all";
        };

        terminal = {
          font_family = "0xProto Nerd Font";
          font_size = 13;
        };

        lsp = {
          rust-analyzer = {
            initialization_options = {
              check = {
                command = "clippy";
              };
            };
          };
          nixd = {
            settings = {
              formatting = {
                command = ["alejandra"];
              };
            };
          };
        };

        languages = {
          JavaScript = {
            language_servers = ["tsgo" "!vtsls" "..."];
            formatter = [
              {code_action = "source.fixAll.eslint";}
            ];
            format_on_save = "on";
          };
          TypeScript = {
            language_servers = ["tsgo" "!vtsls" "..."];
            formatter = [
              {code_action = "source.fixAll.eslint";}
            ];
            format_on_save = "on";
          };
          TSX = {
            language_servers = ["tsgo" "!vtsls" "..."];
            formatter = [
              {code_action = "source.fixAll.eslint";}
            ];
            format_on_save = "on";
          };
          Nix = {
            language_servers = ["nixd" "!nil"];
            formatter = {
              external = {
                command = "alejandra";
                arguments = ["-q" "-"];
              };
            };
            format_on_save = "on";
          };
          Python = {
            formatter = {
              external = {
                command = "ruff";
                arguments = ["format" "--stdin-filename" "{buffer_path}" "-"];
              };
            };
            format_on_save = "on";
          };
          Shell = {
            formatter = {
              external = {
                command = "shfmt";
                arguments = ["-i" "2" "-"];
              };
            };
            format_on_save = "on";
          };
          Rust = {
            formatter = "language_server";
            format_on_save = "on";
          };
          Go = {
            formatter = "language_server";
            format_on_save = "on";
          };
          C = {
            formatter = "language_server";
            format_on_save = "on";
          };
          "C++" = {
            formatter = "language_server";
            format_on_save = "on";
          };
          CSS = {
            language_servers = ["tailwindcss-intellisense-css" "!vscode-css-language-server"];
            formatter = "language_server";
            format_on_save = "on";
          };
          TOML = {
            formatter = "language_server";
            format_on_save = "on";
          };
          Lua = {
            formatter = "language_server";
            format_on_save = "on";
          };
          Typst = {
            formatter = "language_server";
            format_on_save = "on";
          };
          Java = {
            formatter = "language_server";
            format_on_save = "on";
          };
        };
      };

      userKeymaps = [
        {
          context = "Editor && vim_mode == normal && !menu";
          bindings = {
            "space f f" = "file_finder::Toggle";
            "space f g" = "workspace::NewSearch";
            "space f c" = "tab_switcher::Toggle";
            "space f d" = "project_symbols::Toggle";
            "shift-k" = "editor::Hover";
            "ctrl-k" = "vim::ScrollUp";
            "ctrl-j" = "vim::ScrollDown";
            ";" = "command_palette::Toggle";
            "'" = "project_panel::ToggleFocus";
            "space t" = "terminal_panel::ToggleFocus";
            "space a" = "agent::ToggleFocus";
          };
        }
        {
          context = "VimControl && !menu";
          bindings = {
            "space c d" = "editor::Hover";
            "space c a" = "editor::ToggleCodeActions";
            "space l r" = "editor::Rename";
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
            "ctrl-shift-a" = "agent::ToggleFocus";
          };
        }
      ];
    };
  };
}
