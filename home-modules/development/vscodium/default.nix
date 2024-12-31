{
  pkgs,
  config,
  lib,
  ...
}: {
  programs.vscode = lib.mkIf config.development.vscodium.enable {
    enable = true;
    package = pkgs.vscodium.fhsWithPackages (
      ps:
        with ps; [
          gcc
        ]
    );
    mutableExtensionsDir = false;
    extensions = with pkgs.vscode-extensions; [
      # general
      enkia.tokyo-night
      supermaven.supermaven
      esbenp.prettier-vscode
      usernamehw.errorlens
      vscodevim.vim
      ms-azuretools.vscode-docker

      # utilities
      ms-vscode-remote.remote-ssh
      # tomoki1207.pdf

      # nix
      bbenoist.nix
      kamadorueda.alejandra
      jnoortheen.nix-ide

      # c/c++
      ms-vscode.cpptools

      # webdev/js land
      unifiedjs.vscode-mdx
      dbaeumer.vscode-eslint
      yoavbls.pretty-ts-errors
      bradlc.vscode-tailwindcss
      astro-build.astro-vscode
      prisma.prisma
      formulahendry.auto-close-tag
      formulahendry.auto-rename-tag

      # sh
      foxundermoon.shell-format

      # latex
      james-yu.latex-workshop
    ];
    enableUpdateCheck = false;
    # lib.importJSON gets rid of the quotes on LHS from settings.json and consequently, doesn't work.
    # If you are reading this for some reason and you know a solution, please tell me.
    # userSettings = lib.importJSON ./settings.json;
    keybindings = [
      {
        key = "ctrl+tab";
        command = "workbench.action.nextEditor";
      }
      {
        key = "ctrl+shift+tab";
        command = "workbench.action.previousEditor";
      }
    ];
    userSettings = {
      "[nix]" = {
        "editor.defaultFormatter" = "kamadorueda.alejandra";
      };
      "[css]" = {
        "editor.defaultFormatter" = "vscode.css-language-features";
      };
      "[json]" = {
        "editor.defaultFormatter" = "vscode.json-language-features";
      };
      "[astro]" = {
        "editor.defaultFormatter" = "astro-build.astro-vscode";
      };
      "[c]" = {
        "editor.defaultFormatter" = "ms-vscode.cpptools";
      };
      "[shellscript]" = {
        "editor.defaultFormatter" = "foxundermoon.shell-format";
      };
      "[latex]" = {
        "editor.defaultFormatter" = "James-Yu.latex-workshop";
      };
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "breadcrumbs.enabled" = false;
      "explorer.confirmDragAndDrop" = false;
      "explorer.confirmDelete" = false;
      "editor.cursorSmoothCaretAnimation" = "explicit";
      "terminal.integrated.smoothScrolling" = true;
      "editor.cursorBlinking" = "phase";
      "editor.formatOnSave" = true;
      "editor.formatOnPaste" = true;
      "editor.formatOnType" = true;
      "editor.fontWeight" = "600";
      "editor.fontFamily" = "'0xProto'";
      "editor.fontLigatures" = true;
      "editor.renderLineHighlight" = "all";
      "editor.smoothScrolling" = true;
      "git.openRepositoryInParentFolders" = "never";
      "typescript.updateImportsOnFileMove.enabled" = "always";
      "javascript.updateImportsOnFileMove.enabled" = "always";
      "C_Cpp.clang_format_fallbackStyle" = "LLVM";
      "C_Cpp.clang_format_sortIncludes" = false;
      "workbench.startupEditor" = "none";
      "workbench.statusBar.visible" = false;
      "workbench.sideBar.location" = "right";
      "workbench.activityBar.location" = "top";
      "workbench.editor.enablePreview" = false;
      "window.menuBarVisibility" = "toggle";
      "workbench.colorTheme" = "Tokyo Night Storm";
      "workbench.colorCustomizations" = {
        "[Tokyo Night Storm]" = {
          "foreground" = "#959cbd";
          "panelTitle.activeBorder" = "#3d59a1";
          "panelTitle.activeForeground" = "#bdc7f0";
          "panelTitle.inactiveForeground" = "#959cbd";
          "tab.activeForeground" = "#bdc7f0";
          "tab.inactiveForeground" = "#959cbd";
          "breadcrumb.foreground" = "#959cbd";
          "breadcrumb.focusForeground" = "#bdc7f0";
          "breadcrumb.activeSelectionForeground" = "#bdc7f0";
          "statusBar.foreground" = "#bdc7f0";
          "list.focusForeground" = "#bdc7f0";
          "list.hoverForeground" = "#bdc7f0";
          "list.activeSelectionForeground" = "#bdc7f0";
          "list.inactiveSelectionForeground" = "#bdc7f0";
          "list.inactiveSelectionBackground" = "#202330";
          "sideBar.foreground" = "#959cbd";
          "dropdown.foreground" = "#959cbd";
          "menu.foreground" = "#bdc7f0";
          "menubar.selectionForeground" = "#bdc7f0";
          "input.foreground" = "#959cbd";
          "input.placeholderForeground" = "#959cbd";
          "activityBar.foreground" = "#bdc7f0";
          "activityBar.inactiveForeground" = "#787c99";
          "gitDecoration.ignoredResourceForeground" = "#696d87";
          "editorCodeLens.foreground" = "#7982a9";
        };
      };
      "editor.tokenColorCustomizations" = {
        "[Tokyo Night Storm]" = {
          "textMateRules" = [
            {
              "scope" = [
                "comment keyword.codetag.notation"
                "comment.block.documentation keyword"
                "comment.block.documentation storage.type.class"
              ];
              "settings" = {
                "foreground" = "#bb9af7";
              };
            }
            {
              "scope" = [
                "comment.block.documentation entity.name.type.instance"
              ];
              "settings" = {
                "foreground" = "#73daca";
                "fontStyle" = "italic";
              };
            }
            {
              "scope" = [
                "comment.block.documentation entity.name.type punctuation.definition.bracket"
              ];
              "settings" = {
                "foreground" = "#bb9af7";
              };
            }
            {
              "scope" = [
                "comment.block.documentation variable"
              ];
              "settings" = {
                "foreground" = "#e0af68";
                "fontStyle" = "italic";
              };
            }
          ];
        };
      };
    };
  };
}
