# Language packs

`/smartmem-lang-init` installs per-language behavioral skills, tech-stack notes, and LSP/MCP suggestions into a smartmem project.

## Available packs

| Language | Skills | Suggested LSP | Tools mentioned |
|---|---|---|---|
| Python | `python-style`, `python-testing` | pyright / pylsp | ruff, mypy, pytest |
| TypeScript | `typescript-style`, `typescript-testing` | typescript-language-server | eslint, prettier, vitest, jest |
| Go | `go-style` | gopls | golangci-lint, go test |
| Rust | `rust-style` | rust-analyzer | clippy, cargo |
| Java | `java-style` | jdtls | spotless, junit, maven, gradle |
| C# / .NET | `csharp-style` | OmniSharp / csharp-ls | dotnet test, dotnet format |

## What gets installed

For each language `<lang>` you select:

| Target | What | Idempotent? |
|---|---|---|
| `<project>/.claude/skills/<skill-name>/SKILL.md` | Behavioral skill (style + testing rules) | Skip if exists |
| `<project>/memory/tech_context.md` | Append toolchain + commands section, wrapped in `<!-- smartmem:lang:<lang> -->` markers | Skip if marker present |
| `<project>/memory/mcp_suggestions.md` | Append `.mcp.json` snippet for the language's LSP (only if `--with-mcp`) | Skip if marker present |
| `<project>/.claude/smartmem/v1/config.json` | Append `<lang>` to `languages` array | Skip if already listed |

## How LSP integration works

smartmem doesn't run an LSP itself — Claude Code doesn't have built-in LSP support. Instead we suggest **MCP servers that wrap LSPs**, e.g. `language-server-mcp`. Once registered in `.mcp.json`:

```jsonc
{
  "mcpServers": {
    "lsp-py": {
      "command": "npx",
      "args": ["-y", "language-server-mcp", "--lsp", "pyright-langserver", "--lsp-args", "--stdio"]
    }
  }
}
```

…Claude can call MCP tools like `definition`, `references`, `hover` for type-aware navigation. Restart Claude Code, verify with `/mcp`.

## Adding your own language pack

Inside the smartmem source repo:

1. Create `plugins/smartmem-core/language-packs/<lang>/skills/<skill-name>/SKILL.md`.
2. Add `tech_context.snippet.md` and (optional) `mcp_suggestions.md`.
3. Append a row to `language-packs/manifest.json`.
4. Bump plugin version, commit, push.

The new language appears in `/smartmem-lang-init`'s next run.

## Multi-language projects

Run `/smartmem-lang-init` once per language, or pick multiple at the multi-select prompt. Each pack's marker is unique per language so they don't conflict in `tech_context.md`.
