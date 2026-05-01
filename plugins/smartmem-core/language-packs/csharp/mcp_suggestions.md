## Suggested MCP servers for C# projects

- **language-server-mcp** with `csharp-ls` (lighter than OmniSharp):
  ```json
  {
    "mcpServers": {
      "lsp-cs": {
        "command": "npx",
        "args": ["-y", "language-server-mcp", "--lsp", "csharp-ls"]
      }
    }
  }
  ```
