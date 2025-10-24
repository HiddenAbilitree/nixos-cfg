{
  imports = [
    ./desktop
    ./misc
    ./shell
  ];

  programs = {
    git = {
      enable = true;
      settings.user = {
        name = "Eric Zhang";
        email = "me@ericzhang.dev";
      };
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
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      nix-direnv.enable = true;
      silent = true;
    };
  };
}
