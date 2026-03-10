{
  config,
  lib,
  pkgs,
  prismlauncher,
  ...
}: {
  imports = [
    ./lutris.nix
    ./roblox.nix
  ];

  options.desktop.games = {
    enable = lib.mkEnableOption "Games";
    lutris.enable = lib.mkEnableOption "lutris";
    minecraft.enable = lib.mkEnableOption "Minecraft";
    osu.enable = lib.mkEnableOption "osu!";
    roblox.enable = lib.mkEnableOption "Roblox";
    emulators.enable = lib.mkEnableOption "emulators";
  };

  config = lib.mkIf config.desktop.games.enable {
    desktop.games = {
      osu.enable = lib.mkDefault true;
      minecraft.enable = lib.mkDefault true;
      lutris.enable = lib.mkDefault true;
      roblox.enable = lib.mkDefault true;
      emulators.enable = lib.mkDefault false;
    };

    home = {
      packages = with pkgs;
        [
          deadlock-mod-manager
          mangohud
          (lib.mkIf config.desktop.games.osu.enable osu-lazer-bin)
          (lib.mkIf config.desktop.games.emulators.enable (
            retroarch.withCores (
              cores:
                with cores; [
                  mgba
                  dolphin
                  citra
                ]
            )
          ))
        ]
        ++ lib.optionals config.desktop.games.minecraft.enable [
          lunar-client
          (prismlauncher.packages.${pkgs.stdenv.hostPlatform.system}.prismlauncher.override {
            jdks = [
              graalvmPackages.graalvm-ce
              zulu25
              zulu21
              zulu17
              zulu8
            ];
          })
        ];

      file = {
        ".local/share/PrismLauncher/themes/Tokyo-Night-Storm" = {
          inherit (config.desktop.games.minecraft) enable;
          source = ./prism-launcher;
        };
      };
    };
  };
}
