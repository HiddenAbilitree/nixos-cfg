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

  venvName = "cs682";
  venvRoot = ".venvs/${venvName}";
  allowedInterpreters = [ "${config.home.homeDirectory}/${venvRoot}/bin/python" ];

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

    home.file."${venvRoot}/bin/python".source = "${pythonEnv}/bin/python";
    home.file."${venvRoot}/pyvenv.cfg".text = ''
      home = ${pythonEnv}/bin
      include-system-site-packages = true
      version = ${python.version}
      prompt = ${venvName}
    '';

    xdg = {
      configFile = {
        "Positron/User/settings.json".source = (pkgs.formats.json { }).generate "positron-settings.json" (
          (lib.importJSON ./settings.json)
          // {
            "python.interpreters.override" = allowedInterpreters;
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
