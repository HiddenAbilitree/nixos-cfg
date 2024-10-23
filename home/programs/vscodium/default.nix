{ pkgs, lib, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium.fhsWithPackages (
      ps: with ps; [
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

      # utilities
      tomoki1207.pdf

      # nix
      bbenoist.nix
      brettm12345.nixfmt-vscode
      jnoortheen.nix-ide

      # c/c++
      ms-vscode.cpptools

      # webdev/js land
      dbaeumer.vscode-eslint
      yoavbls.pretty-ts-errors
      bradlc.vscode-tailwindcss
      astro-build.astro-vscode
      prisma.prisma
      formulahendry.auto-close-tag
      formulahendry.auto-rename-tag

      # sh
      foxundermoon.shell-format
    ];
    enableUpdateCheck = false;
    # lib.importJSON gets rid of the quotes on LHS from settings.json and consequently, doesn't work.
    # If you are reading this for some reason and you know a solution, please tell me.
    # userSettings = lib.importJSON ./settings.json;
    userSettings = {
      "[nix]" = {
        "editor.defaultFormatter" = "brettm12345.nixfmt-vscode";
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
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "explorer.confirmDragAndDrop" = false;
      "explorer.confirmDelete" = false;
      "editor.formatOnSave" = true;
      "editor.formatOnPaste" = true;
      "editor.formatOnType" = true;
      "editor.fontFamily" = "'FiraCode Nerd Font Mono', 'Fira Code', 'Droid Sans Mono', Menlo, Monaco, 'Courier New', monospace, 'Droid Sans Fallback'";
      "editor.fontLigatures" = true;
      "git.openRepositoryInParentFolders" = "never";
      "typescript.updateImportsOnFileMove.enabled" = "always";
      "javascript.updateImportsOnFileMove.enabled" = "always";
      "C_Cpp.clang_format_fallbackStyle" = "LLVM";
      "C_Cpp.clang_format_sortIncludes" = false;
      "workbench.startupEditor" = "none";
      "workbench.sideBar.location" = "right";
      "workbench.activityBar.location" = "top";
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
