# Memory index — marketwatch-etl

## Always-loaded
- [active_context](active_context.md) — current focus, what's on fire
- [tasks](tasks.md) — open / done backlog

## What & why
- [project_brief](project_brief.md) — what marketwatch-etl is, who consumes it
- [product_context](product_context.md) — stakeholders, SLAs, data contracts
- [design_goals](design_goals.md) — idempotency, late-arrival tolerance, cost ceiling

## How
- [architecture](architecture.md) — S3 -> staging -> dbt flow, DAG topology
- [code_structure](code_structure.md) — repo layout, where each piece lives
- [system_patterns](system_patterns.md) — idempotent loads, watermark pattern, retry policy
- [tech_context](tech_context.md) — versions, lint, test, deploy
- [db_structure](db_structure.md) — Snowflake schemas, key tables, migration approach

## History
- [decisions](decisions.md) — ADR-lite log
- [progress](progress.md) — milestones shipped
- [commands](commands.md) — frequently-run commands
