# התחלה מהירה

אתחלו כל פרויקט Claude Code עם זיכרון היררכי תוך פחות מ-60 שניות.

## התקנה (חד-פעמית, פר מכונה)

בחרו אחת:

### מ-GitHub (מומלץ)
```
claude plugin marketplace add habuba/smartmem
claude plugin install smartmem-core@smartmem
```

### מ-clone מקומי (offline / סביבה מוגבלת)
```bash
git clone https://github.com/habuba/smartmem.git
cd smartmem

# Windows
pwsh scripts\install.ps1

# Linux/macOS/WSL
bash scripts/install.sh
```

הפעילו מחדש את Claude Code. ודאו:
```
claude plugin list
```

## אתחול פרויקט

עברו לתיקיית הפרויקט (ריקה או קיימת — smartmem הוא non-destructive). הפעילו את Claude Code, ואז:

```
/smartmem-init
```

תישאלו **9 שאלות** — ראו [מדריך wizard](02-wizard.md). ברירות המחדל הגיוניות; ניתן להקיש **Enter** על רוב.

לאחר ה-wizard תראו:

```
memory/             ← 19 קבצי זיכרון מפוצלים (סכמת Cline-bank, מורחבת)
docs/               ← BIG_PICTURE, DECISIONS, CHANGELOG, BACKLOG
.claude/smartmem/   ← שכבה חמה (ב-gitignore)
.claude/settings.json (ממוזג, לא נדרס)
CLAUDE.md           ← קובץ מצביע דק (prepended אם כבר קיים)
```

## פיצ׳ר ראשון

```
/prd magic-link "התחברות ללא סיסמה דרך email magic links"
/tasks magic-link
/process
```

`/prd` כותב ל-`docs/prds/magic-link.md`. `/tasks` מרחיב ל-3-12 משימות אטומיות ב-`memory/tasks.md`. `/process` עובד על המשימה הפתוחה הבאה — משתמש אוטומטית בסוכן `planner` לעיצוב וב-`reviewer` לפני קומיט.

## הוספת תמיכה בשפה

```
/smartmem-lang-init
```

בחירה מרובה של שפות: Python, TypeScript, Go, Rust, Java, C#. כל חבילה מתקינה:
- 1-2 skills התנהגותיים (style + testing)
- הוספה ל-`memory/tech_context.md` עם toolchain + פקודות
- הצעת MCP-LSP אופציונלית להדבקה ב-`.mcp.json`

## פקודות יומיומיות

| פקודה | מטרה |
|---|---|
| `/status` | סיכום מסך-אחד: מיקוד, משימות פתוחות, החלטות אחרונות |
| `/task add "..."` / `/task done T-007` | פעולות משימה מהירות |
| `/save-command lint "ruff check ."` | שמירת פקודת shell |
| `/memory-sync` | הרצה ידנית של ה-finalizer (אוטומטי ב-`Stop`/`PreCompact` אם hookMode=full) |
| `/memory-rotate` | ארכוב משימות שהושלמו לפני יותר מ-30 יום |
| `/caveman on\|off\|switch` | החלפת מצב פלט תמציתי |

לעיתים נדירות תצטרכו לערוך קובצי זיכרון ידנית. הסוכן `memory-finalizer` הוא הבעלים שלהם.

## הבא

- [סכמת זיכרון](03-memory-schema.md)
- [מדריך wizard](02-wizard.md)
- [Hooks](04-hooks.md)
- [ארכיטקטורה](05-architecture.md)
- [English](../guide/01-quickstart.md)
