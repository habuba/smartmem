## Suggested MCP servers for Java projects

- **language-server-mcp** with `jdtls`:
  ```json
  {
    "mcpServers": {
      "lsp-java": {
        "command": "npx",
        "args": ["-y", "language-server-mcp", "--lsp", "jdtls"]
      }
    }
  }
  ```

`jdtls` is heavy — first start indexes the project. Be patient.
