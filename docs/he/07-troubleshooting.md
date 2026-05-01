# פתרון בעיות

## התקנה

**`claude plugin marketplace add` נכשל "not found"** — ודאו את ה-URL: `claude plugin marketplace add habuba/smartmem`. בדקו `claude plugin marketplace list`.

**התקנת symlink נכשלת ב-Windows** — symlinks דורשים Developer Mode (Settings → For developers → Developer Mode) או shell מורם הרשאות. או השתמשו ב-`pwsh scripts\install.ps1 -Copy`.

## Wizard

**"You cannot call a method on a null-valued expression"** — תוקן ב-v0.2+. עדכנו עם `claude plugin update smartmem-core`.

**קובץ overlay לא ניצח** — overlay מופעל *לפני* base, אז `system_patterns.md` של ה-overlay אמור להופיע, לא הגנרי. אם רואים תוכן לא נכון — מחקו את הקובץ והריצו שוב.

**קבצי זיכרון בעברית נכתבו אבל התוכן באנגלית** — הרצתם את ה-wizard עם `memoryLanguage: en`; התוכן ננעל באתחול ראשון. להחליף: מחקו `memory/*.md`, הריצו עם `memoryLanguage: he`.

## Hooks

**hooks לא מופעלים ב-Windows** — צריך `pwsh` (PowerShell 7+) ב-PATH, לא Windows PowerShell 5.1. בדיקה: `pwsh -NoProfile -Command 'Write-Host ok'`.

**hooks לא מופעלים ב-Linux/macOS** — `hooks.json` הנוכחי מצביע על `pwsh`. עד שזיהוי אוטומטי יישלח, החליפו ל-bash ב-`hooks.json`.

**`memory-finalizer` לא מופעל ב-Stop** — ודאו `.claude/smartmem/v1/config.json` `hookMode: full`. הפעילו את Claude Code מחדש.

## זיכרון

**subagent כתב ישירות ל-`memory/` במקום `MEMORY_NOTES`** — תקנו את ה-prompt של הסוכן. ואז `/memory-sync` כדי לרכז.

**`active_context.md` מיושן** — finalizer לא רץ. הפעילו ידנית: `/memory-sync`. אם `hookMode: full`, ודאו ש-`Stop` hook מוגדר.

## חבילות שפה

**`/smartmem-lang-init` אומר "language pack not found"** — ודאו `plugins/smartmem-core/language-packs/<lang>/` קיים בפלאגין המותקן.

**שרת MCP לא מתחבר** — ודאו תחביר `.mcp.json`, ש-LSP binary ב-PATH, הפעילו את Claude Code מחדש, הריצו `/mcp`.

## הסרת smartmem

```
claude plugin uninstall smartmem-core
```

קבצי זיכרון, תיעוד, ו-`.claude/smartmem/` נשארים (הם שלכם). להסרה מלאה:

```bash
rm -rf memory/ docs/ .claude/smartmem/
```
