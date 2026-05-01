# חבילות שפה

`/smartmem-lang-init` מתקין skills התנהגותיים פר-שפה, הערות tech-stack, והצעות LSP/MCP בפרויקט smartmem.

## חבילות זמינות

| שפה | Skills | LSP מומלץ | כלים |
|---|---|---|---|
| Python | `python-style`, `python-testing` | pyright / pylsp | ruff, mypy, pytest |
| TypeScript | `typescript-style`, `typescript-testing` | typescript-language-server | eslint, prettier, vitest, jest |
| Go | `go-style` | gopls | golangci-lint, go test |
| Rust | `rust-style` | rust-analyzer | clippy, cargo |
| Java | `java-style` | jdtls | spotless, junit, maven, gradle |
| C# / .NET | `csharp-style` | OmniSharp / csharp-ls | dotnet test, dotnet format |

## מה מותקן

עבור כל שפה `<lang>` שתבחרו:

| יעד | מה | אידמפוטנטי? |
|---|---|---|
| `<project>/.claude/skills/<skill-name>/SKILL.md` | Skill התנהגותי (style + testing) | דילוג אם קיים |
| `<project>/memory/tech_context.md` | הוספת toolchain + פקודות, עטוף ב-`<!-- smartmem:lang:<lang> -->` markers | דילוג אם marker קיים |
| `<project>/memory/mcp_suggestions.md` | snippet `.mcp.json` (רק אם `--with-mcp`) | דילוג אם marker קיים |
| `<project>/.claude/smartmem/v1/config.json` | הוספת `<lang>` למערך `languages` | דילוג אם כבר רשום |

## איך אינטגרציית LSP עובדת

smartmem לא מריץ LSP בעצמו. במקום זאת אנחנו מציעים **שרתי MCP שעוטפים LSPs**, למשל `language-server-mcp`. אחרי רישום ב-`.mcp.json`, Claude יכולה לקרוא לכלי MCP כמו `definition`, `references`, `hover` לניווט מודע-טיפוסים.

## הוספת חבילת שפה משלכם

בתוך מאגר smartmem:

1. צרו `plugins/smartmem-core/language-packs/<lang>/skills/<skill-name>/SKILL.md`.
2. הוסיפו `tech_context.snippet.md` ו-(אופציונלי) `mcp_suggestions.md`.
3. הוסיפו שורה ל-`language-packs/manifest.json`.
4. בצעו bump לגרסה, commit, push.

השפה החדשה תופיע בהפעלה הבאה של `/smartmem-lang-init`.

## פרויקטים רב-לשוניים

הריצו `/smartmem-lang-init` פעם אחת לכל שפה, או בחרו מספר ב-multi-select. ה-marker של כל חבילה ייחודי לשפה כך שלא יתנגשו ב-`tech_context.md`.
