## Suggested MCP servers for TypeScript projects

- **language-server-mcp** with `typescript-language-server`:
  ```json
  {
    "mcpServers": {
      "lsp-ts": {
        "command": "npx",
        "args": ["-y", "language-server-mcp", "--lsp", "typescript-language-server", "--lsp-args", "--stdio"]
      }
    }
  }
  ```
- **playwright-mcp** for end-to-end browser smoke tests.
- **mcp-server-fetch** for hitting your local dev server during UI testing.

Restart Claude Code, verify with `/mcp`.
