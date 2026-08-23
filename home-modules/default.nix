{
  lib,
  osConfig,
  pkgs,
  system,
  ...
}:
{
  imports = [
    ./ai
    ./shell
    ./desktop
  ]
  ++ lib.optionals (lib.hasSuffix "-darwin" system) [ ./darwin ]
  ++ lib.optionals (lib.hasSuffix "-linux" system) [ ./misc ];

  programs = {
    git = {
      enable = true;
      signing.format = null;
      settings = {
        user = {
          name = "Eric Zhang";
          email = "me@ericzhang.dev";
        };
        init.defaultBranch = "main";
        url."git@github.com:".insteadOf = "https://github.com/";
      };
    };

    gh = {
      enable = true;
      package = pkgs.symlinkJoin {
        name = "gh";
        paths = [ pkgs.gh ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/gh \
            --run 'export GH_TOKEN="$(cat ${osConfig.sops.secrets.github-token.path})"'
        '';
        meta = pkgs.gh.meta // {
          mainProgram = "gh";
        };
      };
      settings.git_protocol = "ssh";
    };

    lazygit = {
      enable = true;
      settings = {
        gui = {
          nerdFontsVersion = "3";
          showCommandLog = false;
        };
        git.overrideGpg = true;
        disableStartupPopups = true;
        quitOnTopLevelReturn = true;
      };
      enableZshIntegration = false;
      enableBashIntegration = false;
      enableFishIntegration = false;
      enableNushellIntegration = false;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      nix-direnv.enable = true;
      silent = true;
    };
  };

  xdg.configFile."git/ignore".force = true;
}
