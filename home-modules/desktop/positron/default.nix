{
  config,
  lib,
  osConfig,
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
      pandas
      requests
      tqdm
      (if osConfig.gpu.rocm.enable then torchWithRocm else torch)
    ]
  );

  venvName = "cs682";
  venvRoot = ".venvs/${venvName}";
  allowedInterpreters = [ "${config.home.homeDirectory}/${venvRoot}/bin/python" ];
in
{
  options.desktop.positron.enable = lib.mkEnableOption "Positron";

  config = lib.mkIf config.desktop.positron.enable {
    programs.positron = {
      enable = true;
      profiles.default = {
        mutableUserSettings = true;
        userSettings = (lib.importJSON ./settings.json) // {
          "python.interpreters.override" = allowedInterpreters;
        };
        keybindings = ./keybindings.json;
        extensions = with pkgs.vscode-extensions; [
          enkia.tokyo-night
        ];
      };
    };

    home.file.".positron/extensions/.extensions-immutable.json".onChange = lib.mkForce ''
      run rm $VERBOSE_ARG -f ${lib.escapeShellArg "${config.home.homeDirectory}/.positron/extensions"}/{extensions.json,.init-default-profile-extensions}
    '';

    home.packages = [
      pkgs.gcc
      pkgs.pandoc
      pkgs.texliveFull
      pkgs.inkscape
    ];

    home.file."${venvRoot}/bin/python".source = "${pythonEnv}/bin/python";
    home.file."${venvRoot}/pyvenv.cfg".text = ''
      home = ${pythonEnv}/bin
      include-system-site-packages = true
      version = ${python.version}
      prompt = ${venvName}
    '';

    xdg = {
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
