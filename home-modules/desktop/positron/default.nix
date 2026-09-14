{
  config,
  lib,
  pkgs,
  ...
}:
let
  python = pkgs.python313.override {
    packageOverrides = _: psuper: {
      #   ortools = psuper.ortools.override {
      #     or-tools = (pkgs.or-tools.override { python3 = pkgs.python313; }).overrideAttrs (_: {
      #       doCheck = false;
      #     });
      #   };
    };
  };
  pythonEnv = python.withPackages (
    ps: with ps; [
      ipykernel
      ruff
      nbconvert
      notebook
      numpy
      matplotlib
      scipy
      scikit-image
      # ortools
      opencv-python
      requests
      tqdm
    ]
  );

  extensions = with pkgs.vscode-extensions; [
    enkia.tokyo-night
  ];
in
{
  options.desktop.positron.enable = lib.mkEnableOption "Positron";

  config = lib.mkIf config.desktop.positron.enable {
    home.packages = [
      pkgs.positron-bin
      pkgs.gcc
      pkgs.pandoc
      pkgs.texliveFull
      pkgs.inkscape
    ];

    home.file.".positron/extensions" = {
      source = "${
        pkgs.buildEnv {
          name = "positron-extensions";
          paths = extensions;
        }
      }/share/vscode/extensions";
      recursive = true;
      onChange = ''
        run rm $VERBOSE_ARG -f ${lib.escapeShellArg "${config.home.homeDirectory}/.positron/extensions"}/{extensions.json,.init-default-profile-extensions}
      '';
    };

    xdg = {
      configFile = {
        "Positron/User/settings.json".source = (pkgs.formats.json { }).generate "positron-settings.json" (
          (lib.importJSON ./settings.json)
          // {
            "python.interpreters.include" = [ "${pythonEnv}/bin/python" ];
          }
        );

        "Positron/User/keybindings.json".source = ./keybindings.json;
      };
      dataFile."jupyter/kernels/cs/kernel.json".source =
        (pkgs.formats.json { }).generate "cs-kernel.json"
          {
            argv = [
              "${pythonEnv}/bin/python"
              "-m"
              "ipykernel_launcher"
              "-f"
              "{connection_file}"
            ];
            display_name = "Python (cs)";
            language = "python";
          };
    };
  };
}
