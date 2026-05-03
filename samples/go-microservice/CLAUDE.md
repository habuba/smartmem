# ledgerd

Append-only ledger service. gRPC API, Kafka event stream, Postgres backing store.
Owns the source of truth for monetary movement across the platform — every other
service reads from us or subscribes to our event stream.

## Memory pointers
@memory/MEMORY.md
@memory/active_context.md

## Rules
- Single writer for memory: only `memory-finalizer` touches `memory/*.md`. Other
  agents emit `MEMORY_NOTES:` blocks.
- Do not introduce global state. Pass `context.Context` through every layer; no
  `context.Background()` outside `main` and tests.
- Wrap errors with `fmt.Errorf("...: %w", err)`. Never swallow.
- New SQL goes through sqlc — no hand-rolled `db.Query` in service code.
- Public gRPC API is frozen at v1. Breaking changes require a v2 service and a
  decision entry in `memory/decisions.md`.
- Every write path must be idempotent via `idempotency_key`. No exceptions.
- Tests are table-driven and run with `-race`. PRs without `-race` clean don't merge.
- Before non-trivial changes, read the relevant memory pointer:
  - schema → `memory/db_structure.md`
  - RPC surface → `memory/api_surface.md`
  - latency budgets → `memory/system_requirements.md` (NFR-LAT-*)
  - deployment → `memory/architecture.md`
- Workflow: `/prd <slug>` → `/tasks <slug>` → `/process`.
