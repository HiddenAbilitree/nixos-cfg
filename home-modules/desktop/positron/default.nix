{
  config,
  lib,
  nixpkgs-torch,
  osConfig,
  pkgs,
  ...
}:
let
  pythonPkgs =
    if osConfig.gpu.rocm.enable then
      nixpkgs-torch.legacyPackages.${pkgs.stdenv.hostPlatform.system}
    else
      pkgs;
  python = pythonPkgs.python313;
  pythonEnv = python.withPackages (
    ps:
    let
      torch = if osConfig.gpu.rocm.enable then ps.torchWithRocm else ps.torch;
      torchvision = (ps.torchvision.override { inherit torch; }).overridePythonAttrs (old: {
        env =
          old.env
          // lib.optionalAttrs torch.rocmSupport {
            FORCE_CUDA = 1;
            PYTORCH_ROCM_ARCH = torch.gpuTargetString;
            ROCM_PATH = torch.rocmtoolkit_joined;
          };
        nativeBuildInputs = old.nativeBuildInputs ++ lib.optionals torch.rocmSupport [ torch.rocmPackages.clr ];
      });
    in
    with ps;
    [
      ipykernel
      ruff
      nbconvert
      notebook
      numpy
      matplotlib
      scipy
      scikit-image
      ortools
      opencv-python
      pandas
      requests
      scikit-learn
      tqdm
      torch
      torchvision
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
