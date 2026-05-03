# Decisions (ADR-lite)

- **2026-01-22 — sqlc over GORM.**
  Reason: query plans visible at compile time, no reflection in the hot path,
  generated code is greppable. Cost: hand-written SQL, no auto-migrations.
  Accepted; the SQL discipline is a feature, not a bug.

- **2026-01-30 — Transactional outbox over direct Kafka publish.**
  Reason: atomicity between DB commit and event emit. A direct publish in the
  request path means either we publish before commit (event for a write that
  rolled back) or after commit (event lost if process dies between). Outbox
  pays a publish-lag cost (~hundreds of ms) for guaranteed exactly-once-effective.

- **2026-02-14 — Append-only with reversing entries; no UPDATE/DELETE.**
  Reason: regulatory (SOX) + auditability. Corrections are first-class entries
  that reference the original. The DB role itself lacks UPDATE/DELETE on
  `ledger_entry` — defense in depth against bugs and bad migrations.

- **2026-02-28 — Postgres partition by month, RANGE(posted_at).**
  Reason: pruning old data must be metadata-only and fast (NFR-CAP-1).
  Considered hash partition by account_id; rejected because the dominant
  read pattern is time-bounded per account, and time-range partitioning
  prunes both the hot scan and the archive job.

- **2026-03-15 — SPIFFE/mTLS for service auth; no API keys.**
  Reason: rotating shared secrets across 4 caller services was already
  painful. SPIFFE identities are issued by the platform, rotated automatically,
  and bind to workload identity, not to a secret in a vault.

- **2026-04-08 — Reject "balance cache in app memory" proposal.**
  Reason: cache invalidation across N replicas under writes is harder than
  the materialized view + on-the-fly fallback we have. Revisit only if
  GetBalance p99 stays > 50ms after T-015 spike.
