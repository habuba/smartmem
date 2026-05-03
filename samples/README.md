# Samples

These are **read-only examples** showing what a smartmem-instrumented project's memory looks like after a few weeks of real work. They are not used by `/smartmem-init` — picking a project type only chooses which memory files are seeded (empty), not the content. Filling content is the user's job over time, with `memory-finalizer` distilling notes from sessions.

Each sample shows:
- A concise root `CLAUDE.md` (≤30–70 lines) with `@`-imports to the always-loaded files and the standard concise + hierarchical-memory + update-mode rules.
- A `memory/MEMORY.md` index listing the chosen file set.
- The actual `memory/<file>.md` files, filled with realistic content in the voice of a senior engineer working in that discipline.

## Disciplines covered

| Sample | Discipline | What it demonstrates |
|---|---|---|
| [`python-data-pipeline`](python-data-pipeline/) | ETL / data engineering | Snowflake DDL in `db_structure`, dbt patterns, real vendor cost figures |
| [`rust-cli-tool`](rust-cli-tool/) | Systems / CLI | anyhow/thiserror split, zero-alloc parsing, criterion bench regression thread |
| [`nextjs-saas`](nextjs-saas/) | Fullstack web | Server Actions migration, multi-tenant scoping rule, Stripe webhook flow |
| [`go-microservice`](go-microservice/) | Distributed services | gRPC + transactional outbox, NFRs with concrete numbers, Kafka rebalance investigation |
| [`ml-training-pipeline`](ml-training-pipeline/) | ML / experimentation | `datasets` / `experiments` / `model_registry` files, focal loss vs sampler reweight thread |
| [`react-native-mobile`](react-native-mobile/) | Mobile | Offline-first patterns, op-sqlite, MapLibre migration, iOS background suspend bug |
| [`embedded-firmware`](embedded-firmware/) | Embedded / RTOS | STM32L4 power budget, FreeRTOS tasks, `hw_context` pin map, sleep current regression |
| [`unity-game`](unity-game/) | Game development | Server-authoritative sim, deterministic RNG, host migration desync thread |
| [`compliance-workflow`](compliance-workflow/) | Business workflow | BPMN-first, `stakeholders` / `processes` / `slas` files, MLR 2017 / GDPR context |
| [`docs-site`](docs-site/) | Docs / DX | Diátaxis taxonomy, runnable samples in CI, contributor ramp metric |

## What you should take away from these

- Memory files stay short. Each one fits on a screen. The signal-to-noise ratio is high because every line is something a future session would actually want to recall.
- The chosen file set varies by discipline. There is no universal 18-file template — pick what fits.
- `active_context.md` is the live thread. It changes session-to-session and tells you what is *actually* happening right now. Everything else changes more slowly.
- `decisions.md` (local) and `docs/DECISIONS.md` (canonical) are ADR-lite: date, context, decision, consequences. Three sentences each, not three paragraphs.
- Custom files are fine. `hw_context`, `content_structure`, `datasets`, `experiments`, `stakeholders`, `slas`, `processes` — none of these are in the default 18, they are added with `/memory-files add` when needed.
