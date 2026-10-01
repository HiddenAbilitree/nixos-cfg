{
  config,
  lib,
  pkgs,
  ...
}:
let
  modelRevision = "511b09642bb324401f15f97cc23bc67e8f0a291d";
  modelBaseUrl = "https://huggingface.co/PaddlePaddle/PaddleOCR-VL-1.6-GGUF/resolve/${modelRevision}";
  model = pkgs.fetchurl {
    url = "${modelBaseUrl}/PaddleOCR-VL-1.6-GGUF.gguf";
    hash = "sha256-865G7IhQUKz0s9MZREMeH9kNUGZPsJEmr0o8BQuhTug=";
  };
  projector = pkgs.fetchurl {
    url = "${modelBaseUrl}/PaddleOCR-VL-1.6-GGUF-mmproj.gguf";
    hash = "sha256-IE11fXYQ2bP6qxDVBtaeWyROMr92XiurLQFn5l4KBYo=";
  };
in
{
  options.paddleocr.enable = lib.mkEnableOption "local AMD GPU PaddleOCR-VL-1.6 recognition";

  config = lib.mkIf config.paddleocr.enable {
    services.llama-cpp = {
      enable = true;
      package = pkgs.llama-cpp-rocm;
      openFirewall = false;
      settings = {
        host = "127.0.0.1";
        port = 8111;
        model = toString model;
        mmproj = toString projector;
        alias = "PaddleOCR-VL-1.6-0.9B";
        device = "ROCm0";
        gpu-layers = "all";
        mmproj-device = "ROCm0";
        mmproj-offload = true;
        fit = "off";
        ctx-size = 16384;
        parallel = 1;
        temp = 0;
      };
    };

    systemd.services.llama-cpp = {
      requires = [
        "dev-kfd.device"
        "dev-dri-renderD128.device"
      ];
      after = [
        "dev-kfd.device"
        "dev-dri-renderD128.device"
      ];
      serviceConfig = {
        SupplementaryGroups = [ "render" ];
        ProcSubset = lib.mkForce "all";
      };
    };
  };
}
