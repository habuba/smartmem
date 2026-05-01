# smartmem ↔ Claude Code auto-memory

Claude Code (v2.1.59+) כולל פיצ׳ר **auto-memory** מובנה. smartmem ו-auto-memory הם *דברים שונים* המשרתים *מטרות שונות*.

## TL;DR

| שכבה | נתיב | היקף | מי כותב | חיים |
|---|---|---|---|---|
| **smartmem `memory/`** | `<project>/memory/*.md` | Repo (committed, משותף לצוות) | סוכן `memory-finalizer` (בלבד) | חיי הפרויקט |
| **smartmem hot tier** | `<project>/.claude/smartmem/v1/` | Repo (gitignored, machine-local) | סוכן `memory-finalizer` | רענן לסשן |
| **Claude auto-memory** | `~/.claude/projects/<git-root>/memory/MEMORY.md` | **Machine-local, פר git repo** | Claude (אוטונומי, דרך `Edit`) | חי בין סשנים על המכונה |

שניהם יכולים להתקיים יחד. הם לא נלחמים.

## מה זה בעצם auto-memory

כש-Claude Code מתחיל סשן, הוא טוען עד **200 שורות / 25 KB** מ-`~/.claude/projects/<git-root>/memory/MEMORY.md`. Claude יכול לעדכן את הקובץ אוטונומית דרך כלי `Edit` כשמשהו נראה שווה לזכור — פקודות build, דפוסי debugging, העדפות סגנון.

עובדות מפתח:

- **פר מכונה**: לעולם לא מסונכרן בין משתמשים או מכונות.
- **פר git repo**: כל ה-worktrees חולקים auto-memory אחד.
- **markdown רגיל**: ניתן לערוך דרך `/memory` או עורך.
- **קבצי topic**: Claude יכול ליצור `debugging.md` ליד `MEMORY.md`. נטענים על-פי דרישה.
- **אין כלי כתיבה**: Claude משתמש ב-`Edit` רגיל; ה-harness עוקב אחרי הנתיב.
- **כיבוי**: `autoMemoryEnabled: false` ב-settings, או `CLAUDE_CODE_DISABLE_AUTO_MEMORY=1`.

תיעוד רשמי: <https://code.claude.com/docs/en/memory.md>

## למה smartmem שומר על `memory/` משלו

| תכונה | smartmem `memory/` | Claude auto-memory |
|---|---|---|
| Committed ל-git | ✓ | ✗ |
| משותף לצוות | ✓ | ✗ |
| schema קבוע (18 קבצים) | ✓ | ✗ |
| Race-free (כותב יחיד) | ✓ | ✗ |
| בטוח-compaction (hooks) | ✓ | ✗ |
| נגיש מ-CI / מחוץ ל-Claude | ✓ | ✗ |
| משטח ל-`/prd → /tasks → /process` | ✓ | ✗ |

## אפשרות ב-wizard

`/smartmem-init` שואל `autoMemory`:

| ערך | התנהגות |
|---|---|
| `keep` (ברירת מחדל, מומלץ) | auto-memory נשאר דלוק. שתי השכבות מתקיימות. |
| `off` | קובע `autoMemoryEnabled: false` ב-`.claude/settings.json`. |
| `mirror` | (ניסיוני) finalizer קורא את auto-memory וממפה רלוונטיות ל-smartmem. |

ניתן להחליף בכל זמן ב-`.claude/smartmem/v1/config.json`.

## איפה כל דבר יושב (מודל מנטלי)

- "אנחנו מריצים בדיקות עם `pytest -x`" → **smartmem** (`memory/commands.md`) — כל המפתחים צריכים.
- "המשתמש מעדיף בלי תגובות מיותרות" → **auto-memory** — העדפה, machine-local.
- "auth flow הוא OAuth2 עם PKCE" → **smartmem** (`memory/architecture.md`) — ארכיטקטורה.
- "בסשן האחרון לא הצלחנו לשחזר באג X" → **auto-memory** — debugging.

## איך לבדוק

```bash
echo "$HOME/.claude/projects/$(git rev-parse --show-toplevel | sed 's:/:-:g; s:^-::')/memory/"
# או דרך Claude Code: /memory ואז "Open auto-memory folder"
```

## כיבוי auto-memory לפרויקט

`autoMemory: off` ב-init כותב:

```json
{ "autoMemoryEnabled": false }
```

ב-`.claude/settings.json`. smartmem ממשיך לעבוד רגיל.
