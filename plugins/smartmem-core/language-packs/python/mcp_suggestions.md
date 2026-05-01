## Suggested MCP servers for Python projects

To give Claude LSP-level navigation (go-to-def, find-refs, hover types), register one of:

- **language-server-mcp** with pyright — best go-to-def + types.
  Add to `.mcp.json`:
  ```json
  {
    "mcpServers": {
      "lsp-py": {
        "command": "npx",
        "args": ["-y", "language-server-mcp", "--lsp", "pyright-langserver", "--lsp-args", "--stdio"]
      }
    }
  }
  ```

- **mcp-server-pytest** (community) — run/inspect tests via MCP.

After adding to `.mcp.json`, restart Claude Code. Verify with `/mcp` (lists active servers).
