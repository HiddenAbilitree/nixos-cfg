{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gpu;
in
{
  options.gpu = {
    vendor = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "amd"
          "nvidia"
        ]
      );
      default = null;
      description = ''
        GPU vendor driving host graphics configuration.
      '';
    };
    rocm.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Install the ROCm compute stack.
      '';
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.vendor != null) {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
    })

    (lib.mkIf (cfg.vendor == "nvidia") {
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia.open = lib.mkDefault true;
    })

    (lib.mkIf (cfg.vendor == "amd") {
      gpu.rocm.enable = lib.mkDefault true;
    })

    (lib.mkIf (cfg.vendor == "amd" && cfg.rocm.enable) {
      hardware.graphics.extraPackages = with pkgs; [
        rocmPackages.clr.icd
        rocmPackages.clr
        rocmPackages.rocminfo
        rocmPackages.rocm-runtime
      ];
      systemd.tmpfiles.rules = [
        "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
      ];
    })

    (lib.mkIf (config.ollama.enable && cfg.vendor != null) {
      services.ollama.package = lib.mkDefault (
        if cfg.vendor == "nvidia" then pkgs.ollama-cuda else pkgs.ollama-rocm
      );
    })
  ];
}
