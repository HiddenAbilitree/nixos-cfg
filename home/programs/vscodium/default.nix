{ pkgs, lib, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium.fhsWithPackages (
      ps: with ps; [
        gcc
      ]
    );
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
    ];
    enableUpdateCheck = false;
    #userSettings = lib.importJSON ./settings.json;
  };
}
