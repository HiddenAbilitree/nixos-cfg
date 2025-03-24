{
  pkgs,
  lib,
  config,
  prismlauncher,
  ...
}: let
  lunarclient = let
    pname = "lunarclient";
    version = "3.3.5";
    src = pkgs.fetchurl {
      url = "https://launcherupdates.lunarclientcdn.com/Lunar%20Client-${version}.AppImage";
      hash = "sha512-DHDo+4qZvsagquMKwdkXG0CBQh0fRPogNdMrOcUbDcisml7/j2sBe+jjOSLOB4ipOB1ULSXmqBugtvb6gDUbzQ==";
    };
    contents = pkgs.appimageTools.extract {inherit pname version src;};
  in
    pkgs.appimageTools.wrapType2 {
      inherit pname version src;

      nativeBuildInputs = [pkgs.makeWrapper];

      extraInstallCommands = ''
        wrapProgram $out/bin/lunarclient \
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
        install -Dm444 ${contents}/lunarclient.desktop -t $out/share/applications/
        install -Dm444 ${contents}/lunarclient.png -t $out/share/pixmaps/
        substituteInPlace $out/share/applications/lunarclient.desktop \
          --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=lunarclient' \
      '';

      meta = with lib; {
        description = "Free Minecraft client with mods, cosmetics, and performance boost";
        homepage = "https://www.lunarclient.com/";
        license = with licenses; [unfree];
        mainProgram = "lunarclient";
        maintainers = with maintainers; [
          Technical27
          surfaceflinger
        ];
        platforms = ["x86_64-linux"];
      };
    };
in {
  imports = [./lutris.nix ./roblox.nix ./honkers.nix];
  home.packages = with pkgs;
    [
      (lib.mkIf config.desktop.games.osu.enable osu-lazer-bin)
      (lib.mkIf config.desktop.games.emulators.enable
        (retroarch.withCores (cores: with cores; [mgba dolphin citra])))
    ]
    ++ lib.optionals config.desktop.games.minecraft.enable [lunarclient prismlauncher.packages.${pkgs.system}.prismlauncher];

  desktop.games = lib.mkIf config.desktop.games.enable {
    osu.enable = lib.mkDefault true;
    minecraft.enable = lib.mkDefault true;
    lutris.enable = lib.mkDefault true;
    roblox.enable = lib.mkDefault true;
    honkers.enable = lib.mkDefault true;
    emulators.enable = lib.mkDefault true;
  };
}
