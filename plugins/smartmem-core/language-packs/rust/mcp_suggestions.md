## Suggested MCP servers for Rust projects

- **language-server-mcp** with `rust-analyzer`:
  ```json
  {
    "mcpServers": {
      "lsp-rust": {
        "command": "npx",
        "args": ["-y", "language-server-mcp", "--lsp", "rust-analyzer"]
      }
    }
  }
  ```
