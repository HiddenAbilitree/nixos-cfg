{
  imports = [./desktop ./development ./misc ./shell];

  programs = {
    git = {
      enable = true;
      userName = "Eric Zhang";
      userEmail = "me@ericzhang.dev";
    };

    lazygit = {
      enable = true;
      settings = {
        gui.nerdFontsVersion = "3";
        git.overrideGpg = true;
      };
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      silent = true;
    };
  };
}
