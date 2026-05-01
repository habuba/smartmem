# סכמת זיכרון

smartmem מפצל את זיכרון הפרויקט ל-**18 קבצים קטנים וממוקדים** המאורגנים בשלוש שכבות. לכל קובץ יש מטרה יחידה וכותב יחיד.

## שכבות

| שכבה | טעון | מתעדכן על ידי |
|---|---|---|
| **Core** (תמיד בהקשר) | בכל סשן | סוכן `memory-finalizer` (כותב יחיד) |
| **Recall** (lazy-loaded דרך `@imports`) | כשרלוונטי | `memory-finalizer` |
| **Hot** (`.claude/smartmem/v1/`, gitignored) | בכל סשן | `memory-finalizer` |
| **Docs** (`docs/`, committed) | על-ידי הפניה | finalizer + בני אדם |

## קבצים

### מה ולמה
| קובץ | מטרה | נערך על ידי |
|---|---|---|
| `memory/project_brief.md` | פסקה אחת: מה הפרויקט ולמה הוא קיים | אתם (ידני) |
| `memory/product_context.md` | משתמשים, בעיות, קריטריוני הצלחה | אתם |
| `memory/design_goals.md` | סדרי עדיפויות וכללי trade-off | אתם |
| `memory/system_requirements.md` | דרישות פונקציונליות + לא-פונקציונליות (FR-/NFR-) | אתם |
| `memory/glossary.md` | מונחים וראשי תיבות ספציפיים | finalizer |

### איך
| קובץ | מטרה | נערך על ידי |
|---|---|---|
| `memory/architecture.md` | ארכיטקטורה ברמה גבוהה, רכיבים, זרימת נתונים | אתם + finalizer |
| `memory/code_structure.md` | איפה הקוד יושב, גבולות מודולים, שמות | finalizer |
| `memory/system_patterns.md` | מוסכמות קוד | finalizer |
| `memory/tech_context.md` | סטאק, build, test, פקודות | finalizer |
| `memory/db_structure.md` | טבלאות, indexes, migrations (דלגו אם אין DB) | finalizer |
| `memory/ui_structure.md` | עץ קומפוננטות, מערכת עיצוב (דלגו אם אין UI) | finalizer |
| `memory/api_surface.md` | נקודות קצה, חוזים (דלגו אם אין API) | finalizer |

### עכשיו והיסטוריה
| קובץ | מטרה | נערך על ידי |
|---|---|---|
| `memory/active_context.md` | מיקוד נוכחי | finalizer (mirror) |
| `memory/tasks.md` | פתוח / חסום / הושלם | task-tracker (דרך finalizer) |
| `memory/progress.md` | append-only milestones | finalizer |
| `memory/commands.md` | פקודות shell בשימוש תכוף | finalizer (דרך `/save-command`) |
| `memory/decisions.md` | mirror של ADR | finalizer |

## האינווריאנט: כותב יחיד

**רק `memory-finalizer` כותב ל-`memory/**`, `.claude/smartmem/**` או `docs/{DECISIONS,CHANGELOG,BACKLOG}.md`.**

כל סוכן אחר פולט בלוקים `MEMORY_NOTES:` בתשובה שלו. ה-finalizer רץ:
- ב-`Stop` (כש-`hookMode: full`)
- ב-`PreCompact` (תמיד, גם ב-`guard`)
- ידנית דרך `/memory-sync`

זה מה שהופך זיכרון היררכי ל-race-free בין subagents ושורד compaction של ההקשר.

## הוספת קבצי זיכרון מותאמים

ניתן להוסיף קבצים מותאמים. שני מסלולים:

1. **לפרויקט יחיד** — צרו `memory/my-file.md` והוסיפו ל-`memory/MEMORY.md`. לא נייד.
2. **לשימוש חוזר בין פרויקטים** — הוסיפו ל-overlay חדש דרך `/smartmem-new-template`. הופך לחלק ממשפחת הפלאגינים.

## קובץ אינדקס

`memory/MEMORY.md` הוא **האינדקס, אף פעם לא התוכן** — שורה אחת לכל קובץ, ≤200 שורות. Claude Code קוראת אותו ראשון, ואז מבצעת `@imports` רק לקבצים שצריך.
