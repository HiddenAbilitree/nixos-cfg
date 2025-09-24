{
  pkgs,
  config,
  ...
}: {
  # home.file.".config/helix/themes/tokyo-night-storm.toml" = {
  #   text = builtins.readFile ./tokyonight.toml;
  #   inherit (config.shell.helix) enable;
  # };
  programs.helix = {
    inherit (config.shell.helix) enable;
    # themes = builtins.fromTOML (builtins.readFile ./tokyonight.toml);
    extraPackages = [
      pkgs.astro-language-server
      pkgs.clang-tools
      pkgs.docker-compose-language-service
      pkgs.dockerfile-language-server
      pkgs.go-tools
      pkgs.gopls
      pkgs.lldb
      pkgs.mdx-language-server
      pkgs.prettierd
      pkgs.ruff
      pkgs.rust-analyzer
      pkgs.tinymist
      pkgs.typescript-language-server
      pkgs.vscode-langservers-extracted
      pkgs.yaml-language-server
      pkgs.zls
    ];
    settings = {
      theme = "tokyonight_storm";
      editor = {
        line-number = "relative";
        cursor-shape = {
          normal = "block";
          insert = "bar";
          # select = "underline";
        };
        lsp = {
          # display-inlay-hints = true;
        };
        soft-wrap.enable = true;
        end-of-line-diagnostics = "hint";
        indent-guides = {
          character = "┊";
          render = true;
          skip-levels = 1;
        };
        jump-label-alphabet = "sadfjklewcmpgh";
        file-picker = {
          hidden = false;
        };
      };
      keys = {
        normal = {
          "C-g" = [
            ":write-all"
            ":new"
            ":insert-output lazygit"
            ":set mouse false"
            ":set mouse true"
            ":buffer-close!"
            ":redraw"
            ":reload-all"
          ];
          ";" = "command_mode";
          # "V" = "extend_line_below";
          "esc" = "collapse_selection";
          "K" = "hover";
          "g" = {
            j = "goto_last_line";
            k = "goto_file_start";
          };
        };
        select = {
          g = {
            j = "goto_last_line";
            k = "goto_file_start";
          };
        };
      };
    };
    languages = {
      language = let
        typescript = {
          auto-format = true;
          language-servers = [
            "typescript-language-server"
            "vscode-eslint-language-server"
            "typos"
          ];
          roots = ["tsconfig.json"];
          formatter = {
            command = "prettierd";
            args = [
              "%{buffer_name}"
            ];
          };
        };
        mkTypescript = extra: typescript // extra;
      in [
        {
          name = "astro";
          language-servers = [
            "astro-ls"
            "vscode-eslint-language-server"
            "typos"
          ];
          auto-format = true;
          formatter = {
            command = "prettierd";
            args = [
              "%{buffer_name}"
            ];
          };
          file-types = [
            "astro"
          ];
        }
        {
          name = "markdown";
          auto-format = true;
          language-servers = [
            "marksman"
            "markdown-oxide"
            "mdx-language-server"
            "vscode-eslint-language-server"
            "typos"
          ];
          formatter = {
            command = "prettierd";
            args = [
              "%{buffer_name}"
            ];
          };
        }
        {
          name = "nix";
          auto-format = true;
          formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
          language-servers = [
            "nixd"
            "nil"
            "typos"
          ];
        }
        (mkTypescript {
          name = "typescript";
        })
        (mkTypescript {
          name = "tsx";
        })
        (mkTypescript {
          name = "javascript";
        })
        {
          name = "rust";
          auto-format = true;
          language-servers = [
            "rust-analyzer"
            "typos"
          ];
        }
        {
          name = "haskell";
          auto-format = true;
          formatter = {
            command = "fourmolu";
            args = [
              "--stdin-input-file"
              "%{buffer_name}"
            ];
          };
          language-servers = [
            "haskell-language-server"
            "typos"
          ];
        }
        {
          name = "cpp";
          auto-format = true;
          file-types = [
            "cc"
            "cpp"
            "hpp"
          ];
        }
        {
          name = "python";
          auto-format = true;
          formatter = {
            command = "ruff";
            args = [
              "format"
              "--stdin-filename"
              "%{buffer_name}"
            ];
          };
        }
        {
          name = "yaml";
          auto-format = true;
          formatter = {
            command = "prettierd";
            args = [
              "%{buffer_name}"
            ];
          };
          language-servers = [
            "yaml-language-server"
            "typos"
          ];
        }
        {
          name = "docker-compose";
          auto-format = true;
          formatter = {
            command = "prettierd";
            args = [
              "%{buffer_name}"
            ];
          };
          language-servers = [
            "docker-compose-langserver"
            "yaml-language-server"
            "typos"
          ];
        }
      ];
      language-server = {
        rust-analyzer = {
          config.check = "clippy";
        };
        clangd = {
          command = "${pkgs.clang-tools}/bin/clangd";
          clangd.fallbackFlags = ["-std=c++23"];
        };
        gopls = {
          config = {
            staticcheck = true;
          };
        };
        typos = {
          command = "${pkgs.typos-lsp}/bin/typos-lsp";
        };
        vscode-eslint-language-server = {
          command = "/Users/kunet/.bun/bin/vscode-eslint-language-server";
          args = ["--stdio"];
          config = {
            validate = "on";
            quiet = false;
            experimental.useFlatConfig = true;
            problems.shortenToSingleLine = false;
            run = "onType";
            nodePath = "";
            rulesCustomizations = [];
            codeAction = {
              disableRuleComment = {
                enable = true;
                location = "separateLine";
              };
              showDocumentation.enable = true;
            };
            workingDirectory.mode = "auto";
          };
        };
      };
    };
  };
}
