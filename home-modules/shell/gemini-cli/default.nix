{
  config,
  lib,
  ...
}: {
  options.shell.gemini-cli.enable = lib.mkEnableOption "Gemini CLI";

  config = lib.mkIf config.shell.gemini-cli.enable {
    programs.gemini-cli = {
      enable = true;
      defaultModel = "gemini-3-pro-preview";
      settings = {
        general = {
          preferredEditor = "nvim";
          previewFeatures = true;
        };
        mcpServers = {
          ESLint = {
            command = "bunx";
            args = ["@eslint/mcp@latest"];
          };
        };
        security.auth.selectedType = "oauth-personal";
      };
    };
  };
}
