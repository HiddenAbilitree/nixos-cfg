{pkgs, ...}: {
  imports = [
    ../../../home-modules/desktop/spicetify
    ./programs
  ];

  shell = {
    enable = true;
    zellij.autostart = false;
  };

  desktop.spicetify.enable = true;

  home.packages = with pkgs; [
    brave
    nerd-fonts._0xproto
    obsidian
    raycast
    zed-editor
  ];

  programs = {
    kitty = {
      enable = true;
      font = {
        name = "0xProto Nerd Font";
        size = 11;
      };
      themeFile = "tokyo_night_storm";
      settings = {
        background_opacity = "0.9";
        macos_option_as_alt = "yes";
      };
    };

    mpv.enable = true;
  };

  targets.darwin = {
    copyApps.enable = true;
    linkApps.enable = false;
  };
}
