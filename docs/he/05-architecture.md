# ארכיטקטורה

איך smartmem עצמו בנוי.

## משפחת פלאגינים

```
.claude-plugin/marketplace.json
└── 6 פלאגינים
    ├── smartmem-core            ← המנוע
    ├── smartmem-software        ← overlay: ספריות קוד-בלבד
    ├── smartmem-fullstack       ← overlay: frontend + backend
    ├── smartmem-business        ← overlay: workflows לא-קוד
    ├── smartmem-data            ← overlay: פרויקטי data/ML
    └── smartmem-cli             ← overlay: כלי CLI
```

Overlays תלויים ב-`smartmem-core`. התקנת core לבד נותנת לכם את הבסיס הגנרי. הוספת overlay מתמחה כמה קבצי זיכרון.

## הזרימה

```
/smartmem-init → AskUserQuestion × 9 → wizard.{ps1|sh}
   ↓
   העלה overlay ראשון (קבצים מתמחים מנצחים)
   ↓
   העלה base manifest (en או he) — מילוי השאר כ-create-only
   ↓
   רנדור {{name}}, {{description}}, {{MODEL_*}}, {{date}}, {{memoryLanguage}}
   ↓
   json-merge .claude/settings.json
   overwrite-runtime .claude/smartmem/v1/config.json
   append-once .gitignore
   ↓
   אם המשתמש בחר "התקן חבילת שפה עכשיו": /smartmem-lang-init
   ↓
   סיכום: /status, /prd, /tasks, /process
```

## אסטרטגיות מיזוג

| אסטרטגיה | הרצה ראשונה | הרצה חוזרת |
|---|---|---|
| `create-only` | כתיבה | דילוג (שומר על עריכות המשתמש) |
| `prepend-once` | כתיבה עם marker | דילוג אם marker קיים |
| `append-once` | כתיבה עם marker | דילוג אם marker קיים |
| `json-merge` | כתיבה | איחוד מערכים, additive object props |
| `overwrite-runtime` | כתיבה | מיזוג: שדות חדשים מתווספים, קיימים נשמרים (או מוחלפים אם `-Update`) |

## אינווריאנט הכותב היחיד

בחירת עיצוב מרכזית. כל subagent פולט `MEMORY_NOTES:`; רק `memory-finalizer` באמת כותב לזיכרון. זה אומר:
- אין race conditions בין subagents מקבילים.
- הזיכרון שורד compaction של ההקשר.
- ה-audit trail (`event-log.jsonl`) הוא single source of truth.
- hook של `SubagentStop` מזהיר כשסוכן שוכח לפלוט הערות.
