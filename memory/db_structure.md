# DB structure — smartmem

**N/A** — smartmem has no database. State lives in plain markdown and JSON files on disk:

- Durable memory: `<project>/memory/*.md` (committed)
- Durable docs: `<project>/docs/*.md` (committed)
- Runtime state: `<project>/.claude/smartmem/v1/{config.json, active_context.md, event-log.jsonl}` (gitignored)

Event log format (`event-log.jsonl`):
```json
{"ts": "2026-05-01T12:34:56Z", "agent": "memory-finalizer", "wrote": ["memory/decisions.md"], "notes_count": 3}
```

If a future feature needs an actual database (e.g. cross-machine sync), this file should be updated with engine, schema, migration tool, and conventions per the standard `db_structure.md` template.
