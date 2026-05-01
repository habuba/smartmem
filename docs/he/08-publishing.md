# פרסום fork משלכם

ניתן לעשות fork ל-smartmem, להתאים ולפרסם marketplace משלכם.

## Fork ושינוי שם

1. Fork ב-GitHub.
2. החליפו `smartmem` → `<your-name>` (או השאירו את שם המשפחה).
3. ערכו `.claude-plugin/marketplace.json` שדה `owner`.
4. בצעו bump לכל `version` ב-plugin.json ל-`0.1.0`.
5. Commit + push.

## פרסום release

```bash
git add -A
git commit -m "v0.x.y"
git tag v0.x.y
git push --tags
```

משתמשים יתקינו עם:
```
claude plugin marketplace add <you>/<your-fork>
claude plugin install smartmem-core@<your-fork>
```

עדכונים מתבצעים עם:
```
claude plugin update --all
```

## הוספת project-type מותאם

בתוך מאגר ה-clone, הריצו ב-Claude Code:
```
/smartmem-new-template
```

ענו על השאלות (שם, base, תיאור, קבצי זיכרון נוספים, subagents, commands).

ה-skill כותב `plugins/smartmem-<name>/`, רושם ב-`marketplace.json`, ומדפיס פקודת test-install.

## מדיניות גרסאות

- **Patch** (`0.x.Y`) — תיקוני באגים, עדכוני תיעוד, ללא שינויי schema.
- **Minor** (`0.X.y`) — קבצי זיכרון חדשים, פקודות חדשות, overlays חדשים. תאימות לאחור דרך `/project-update`.
- **Major** (`X.y.z`) — שינויי schema השוברים פרויקטים קיימים. הוסיפו הערות migration ב-`docs/CHANGELOG.md`.
