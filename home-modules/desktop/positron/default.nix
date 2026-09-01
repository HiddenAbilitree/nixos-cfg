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
in
{
  options.desktop.positron.enable = lib.mkEnableOption "Positron";

  config = lib.mkIf config.desktop.positron.enable {
    home.packages = [ pkgs.positron-bin ];

    xdg.configFile."Positron/User/settings.json".source =
      (pkgs.formats.json { }).generate "positron-settings.json"
        {
          "files.associations" = {
            "**/.posit/ai/providers.json" = "jsonc";
            "**/.posit/ai/auth/data.json" = "jsonc";
            "**/.posit/assistant/settings.json" = "jsonc";
            "renv.lock" = "json";
          };
          "python.interpreters.include" = [ "${pythonEnv}/bin/python" ];
          "ruff.importStrategy" = "fromEnvironment";
        };

    xdg.dataFile."jupyter/kernels/cs/kernel.json".source =
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
}
