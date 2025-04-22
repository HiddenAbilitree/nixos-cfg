{pkgs, ...}: {
  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    packages = with pkgs;
      [
        inter
        dejavu_fonts
        noto-fonts
        noto-fonts-extra
        babelstone-han
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        ubuntu_font_family
        liberation_ttf
      ]
      ++ (with pkgs.nerd-fonts; [
        fira-code
        _0xproto
        jetbrains-mono
      ]);

    fontconfig.defaultFonts = {
      monospace = [
        "JetBrains Mono"
        "FiraCode"
        "DejaVu Sans Mono"
        "Noto Sans Mono CJK SC"
        "Noto Sans Mono CJK TC"
      ];

      sansSerif = [
        "Inter"
        "DejaVu Sans"
        "Noto Sans CJK SC"
        "Noto Sans CJK TC"
        "JetBrains Mono"
        "FiraCode"
      ];

      serif = [
        "DejaVu Serif"
        "Noto Serif CJK SC"
        "Noto Serif CJK TC"
        "JetBrains Mono"
        "FiraCode"
      ];
    };
  };
}
