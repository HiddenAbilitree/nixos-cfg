{
  config,
  lib,
  ...
}:
{
  options.shell.zsh.nvimFilter = {
    enable = lib.mkEnableOption "exclude binary file extensions from nvim tab completion";

    extensions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        # images
        "png"
        "jpg"
        "jpeg"
        "gif"
        "webp"
        "bmp"
        "tif"
        "tiff"
        "ico"
        "avif"
        "heic"
        # video
        "mp4"
        "mkv"
        "mov"
        "avi"
        "webm"
        "flv"
        "m4v"
        # audio
        "mp3"
        "flac"
        "wav"
        "ogg"
        "m4a"
        "opus"
        "aac"
        # documents
        "pdf"
        "doc"
        "docx"
        "xls"
        "xlsx"
        "ppt"
        "pptx"
        "odt"
        "ods"
        "odp"
        "epub"
        # archives
        # "zip"
        # "tar"
        # "gz"
        # "bz2"
        # "xz"
        # "zst"
        # "7z"
        # "rar"
        # "tgz"
        # "jar"
        # binaries
        "bin"
        "iso"
        "dmg"
        "exe"
        "msi"
        "deb"
        "rpm"
        "apk"
        "so"
        "o"
        "a"
        "dll"
        "class"
        "pyc"
        # fonts
        "ttf"
        "otf"
        "woff"
        "woff2"
      ];
    };
  };

  config = lib.mkIf (config.shell.zsh.enable && config.shell.zsh.nvimFilter.enable) {
    programs.zsh.initContent = lib.mkOrder 1500 ''
      _nvim_nobin() {
        _files -g '^*.(${lib.concatStringsSep "|" config.shell.zsh.nvimFilter.extensions})'
      }
      compdef _nvim_nobin nvim
    '';
  };
}
