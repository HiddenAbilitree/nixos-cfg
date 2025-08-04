{
  pkgs,
  config,
  lib,
  ...
}: {
  programs.vscode = {
    inherit (config.desktop.vscodium) enable;
    package = pkgs.vscode.fhsWithPackages (
      ps:
        with ps; [
          gcc
        ]
    );
    mutableExtensionsDir = false;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # general
        ms-vsliveshare.vsliveshare
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
      userSettings = lib.importJSON ./settings.json;
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
    };
  };
}
