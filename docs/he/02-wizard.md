# מדריך `/smartmem-init` (wizard)

ה-wizard רץ בפעם הראשונה שאתם מפעילים `/smartmem-init` בפרויקט. הרצה חוזרת היא non-destructive — היא רק ממלאת שדות חדשים ולעולם לא דורסת זיכרון או תיעוד.

## שאלות

| # | שאלה | ברירת מחדל | הערות |
|---|---|---|---|
| 1 | סוג פרויקט | (אין) | `software-library` / `fullstack-web` / `business-workflow` / `data-ml` / `cli-tool` / `other` |
| 2 | שם פרויקט | שם תיקייה | slug, נמצא ב-CLAUDE.md ובתיעוד |
| 3 | תיאור | (ריק) | שורה אחת |
| 4 | רמת מודל | `balanced` | `frugal` (כל haiku) / `balanced` / `premium` |
| 5 | מצב hooks | `full` | `off` / `guard` (בטיחות בלבד) / `full` |
| 6 | Caveman תמציתי | `off` | `caveman-plugin` / `our-concise` / `off` |
| 7 | שפת זיכרון | `en` | `en` / `he` / אחר. **מומלץ להשאיר `en` גם כשמשוחחים בשפה אחרת — חוסך 30%-50% tokens.** |
| 8 | Auto-memory | `keep` | `keep` / `off` / `mirror`. ראו [auto-memory](09-auto-memory.md). |
| 9 | להתקין חבילת שפה עכשיו | `no` | אם כן, יריץ `/smartmem-lang-init` אחרי ה-wizard |
| 10 | שרתי MCP | (דלג) | רשימה אופציונלית |

## רמות מודל

| רמה | Finalizer | Task tracker | Explorer | Planner | Reviewer | מקרה שימוש |
|---|---|---|---|---|---|---|
| `frugal` | haiku | haiku | haiku | haiku | haiku | מפתח יחיד רגיש לעלות |
| `balanced` | haiku | haiku | sonnet | opus | sonnet | רוב הצוותים |
| `premium` | sonnet | sonnet | sonnet | opus | sonnet | קריטי, פחות מעברי LLM מקובל |

ניתן לערוך `.claude/smartmem/v1/config.json` מאוחר יותר.

## מצבי hook

| מצב | מה דולק | מתי להשתמש |
|---|---|---|
| `off` | כלום | אתם רוצים אפס קסם אוטומטי; `/memory-sync` ידני |
| `guard` | block-secrets, PreCompact בלבד | רשת ביטחון בלי finalizer אוטומטי |
| `full` | + finalizer ב-Stop, סיכום ב-SessionStart, audit ב-SubagentStop, טעינה מחדש ב-PostCompact | **ברירת מחדל**. זיכרון היררכי race-free |

## Auto-memory

נשמר ב-`config.json` בשדה `autoMemory`. שלושה ערכים:

| ערך | התנהגות |
|---|---|
| `keep` (ברירת מחדל) | auto-memory המובנית של Claude Code ב-`~/.claude/projects/<git-root>/memory/` נשארת דלוקה. שתי השכבות מתקיימות. |
| `off` | ה-wizard כותב `autoMemoryEnabled: false` ל-`.claude/settings.json`. Claude לא יקרא/יכתוב auto-memory ב-repo הזה. |
| `mirror` | ניסיוני. ה-finalizer קורא את auto-memory וממפה את העובדות הרלוונטיות ל-smartmem. |

הסבר מלא: [smartmem ↔ auto-memory](09-auto-memory.md).

## שפת זיכרון

נשמר ב-`config.json` בשדה `memoryLanguage`. כרגע נכלל:

- `en` — אנגלית (ברירת מחדל; מומלץ)
- `he` — עברית

**למה אנגלית מומלצת גם לדוברי עברית/ערבית/CJK**: קבצי זיכרון הם טקסט ש-Claude קוראת מחדש בכל סשן. אנגלית צפופה יותר ב-tokenizer של Claude. אותו תוכן בעברית הוא בערך 30%-50% יותר tokens. הזיכרון רק צריך להיות קריא מספיק לסקירה ידנית מזדמנת — ו-Claude מסיקה מעליו באותה איכות בכל שפה. שפת השיחה לא תלויה.

לאלץ שפה לא-default: בחרו ב-init, או ערכו `config.json` `memoryLanguage` והריצו שוב `/smartmem-init` (רק יוסיף קבצים חסרים; זיכרון קיים נשאר כפי שהוא).

## הרצה חוזרת

בטוחה בכל זמן. ה-wizard:
- **מדלג** על כל `memory/*.md` ו-`docs/*.md` קיים (סמנטיקת `create-only`)
- **ממזג** שדות חדשים ל-`.claude/smartmem/v1/config.json`
- **ממזג** ערכים חדשים ל-`.claude/settings.json` (איחוד `permissions.allow`)
- **מדלג** על `CLAUDE.md` אם בלוק ה-marker של smartmem כבר קיים
- **מדלג** על `.gitignore` אם ה-marker קיים

לאחר עדכון smartmem עצמו (`claude plugin update smartmem-core`), השתמשו ב-`/project-update` — הוא מוסיף שדות template חדשים בלי לשאול שוב שאלות שכבר נענו.
