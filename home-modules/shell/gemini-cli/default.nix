{
  programs.gemini-cli = {
    enable = false;
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
}
