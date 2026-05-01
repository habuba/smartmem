# Hooks

smartmem כולל 6 hooks שמופעלים אוטומטית כשהפלאגין מותקן.

| אירוע | פעולה | ברירת מחדל |
|---|---|---|
| `SessionStart` | הדפסת סיכום `/status` | דלוק |
| `PreCompact` | הרצת `memory-finalizer` להפצה הערות לפני compaction | דלוק |
| `PostCompact` | הזרקה מחדש של `MEMORY.md` + `active_context.md` אחרי compaction | דלוק |
| `Stop` | מורה ל-Claude להפעיל `memory-finalizer` (רק אם `hookMode: full`) | תלוי |
| `SubagentStop` | בדיקה: אזהרה אם subagent לא פלט בלוק `MEMORY_NOTES:` | דלוק (אזהרה) |
| `PreToolUse` (`Write\|Edit`) | חסימת סודות — exit 2 אם זוהה AWS key, GitHub token, JWT וכו׳ | דלוק |

## שדה hookMode

ב-`.claude/smartmem/v1/config.json`:

```jsonc
"hookMode": "full"   // off | guard | full
```

| מצב | block-secrets | PreCompact | PostCompact | SessionStart | Stop finalizer | SubagentStop |
|---|---|---|---|---|---|---|
| `off` | – | – | – | – | – | – |
| `guard` | ✓ | ✓ | – | – | – | – |
| `full` | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |

## חוצה פלטפורמות

כל ה-hooks נשלחים כ-PowerShell `.ps1` (ראשי) עם שווי-ערך bash `.sh` ל-Unix. ה-`hooks.json` מצביע על PowerShell; ב-Linux/macOS, החליפו `pwsh -NoProfile -File ...` ל-`bash ...sh` ב-`hooks.json`.

## כתיבת hooks מותאמים

הוסיפו ל-`.claude/settings.json` בפרויקט שלכם — מתמזג עם hooks של smartmem.

## השבתה זמנית

```
claude plugin disable smartmem-core
```

קבצי הזיכרון נשארים; ה-hooks מפסיקים לפעול.
