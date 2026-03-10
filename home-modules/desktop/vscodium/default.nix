{
  config,
  lib,
  pkgs,
  ...
}: {
  options.desktop.vscodium.enable = lib.mkEnableOption "VSCodium";

  config = lib.mkIf config.desktop.vscodium.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscode.fhsWithPackages (
        ps:
          with ps; [
            gcc
          ]
      );
      mutableExtensionsDir = false;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          ms-vsliveshare.vsliveshare
          enkia.tokyo-night
          supermaven.supermaven
          esbenp.prettier-vscode
          usernamehw.errorlens
          vscodevim.vim
          ms-azuretools.vscode-docker

          ms-vscode-remote.remote-ssh

          bbenoist.nix
          kamadorueda.alejandra
          jnoortheen.nix-ide

          ms-vscode.cpptools

          unifiedjs.vscode-mdx
          dbaeumer.vscode-eslint
          yoavbls.pretty-ts-errors
          bradlc.vscode-tailwindcss
          astro-build.astro-vscode
          prisma.prisma
          formulahendry.auto-close-tag
          formulahendry.auto-rename-tag

          foxundermoon.shell-format

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
  };
}
