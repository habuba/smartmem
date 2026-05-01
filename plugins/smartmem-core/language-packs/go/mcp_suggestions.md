## Suggested MCP servers for Go projects

- **language-server-mcp** with `gopls`:
  ```json
  {
    "mcpServers": {
      "lsp-go": {
        "command": "npx",
        "args": ["-y", "language-server-mcp", "--lsp", "gopls"]
      }
    }
  }
  ```

Verify with `/mcp` after restart.
