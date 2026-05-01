# smartmem — תיעוד בעברית

**אתחול חכם וזיכרון היררכי לפרויקטים של Claude Code.**

פקודה אחת (`/smartmem-init`) מביאה כל פרויקט ממצב ריק למצב מצויד מלא תוך פחות מדקה: קבצי זיכרון היררכיים, סוכן `memory-finalizer` עם כותב יחיד, hooks ששורדים compaction, זרימת `/prd → /tasks → /process`, ועוד — הכל נבחר אינטראקטיבית בזמן ה-init.

---

## דפי מדריך

1. [התחלה מהירה](01-quickstart.md)
2. [מדריך wizard](02-wizard.md)
3. [סכמת זיכרון](03-memory-schema.md)
4. [Hooks](04-hooks.md)
5. [ארכיטקטורה](05-architecture.md)
6. [חבילות שפה](06-language-packs.md)
7. [פתרון בעיות](07-troubleshooting.md)
8. [פרסום fork משלכם](08-publishing.md)

---

## הערה חשובה: שפת הזיכרון

ברירת מחדל היא **אנגלית**, גם אם הצ׳אט שלכם עם Claude מתבצע בעברית.

**למה?** קבצי זיכרון נקראים מחדש בכל סשן. אנגלית צפופה יותר ב-tokens — אותו תוכן בעברית עולה כ-30%-50% יותר tokens. Claude מסיק מעל זיכרון באנגלית באותה איכות בלי קשר לשפת השיחה.

אם אתם רוצים זיכרון בעברית למרות זאת (קריאות אנושית עדיפה לכם), בחרו `memoryLanguage: he` ב-wizard. כל הקבצים יהיו בעברית.

---

## התקנה מהירה

```bash
claude plugin marketplace add habuba/smartmem
claude plugin install smartmem-core@smartmem
```

לאחר מכן בכל פרויקט:
```
/smartmem-init
```

ראו [התחלה מהירה](01-quickstart.md) להמשך.
