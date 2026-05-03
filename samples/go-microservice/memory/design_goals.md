# Design goals

## Hard goals (in priority order)
1. **Durability over latency.** A committed entry never disappears. We `fsync`,
   we synchronous-replicate, we accept the latency cost. If forced to choose
   between losing a write and missing a p99, we miss the p99.
2. **Idempotency end-to-end.** Every write carries an `idempotency_key`. Replays
   from upstream retries must be safe. Network partitions must not double-book.
3. **Append-only.** No UPDATE, no DELETE on `ledger_entry`. Corrections are
   reversing entries. This is a regulatory and an engineering decision.
4. **Auditability.** Every entry has an immutable hash chain back to the prior
   entry per account. Tampering is detectable offline.

## Soft goals
- Operability: one binary, config via env, structured logs, OTel traces by default.
- Boring tech: Postgres + Kafka, no exotic stores. We optimize the schema, not
  the infrastructure.
- Fast local dev: `make dev` brings up Postgres + Kafka + ledgerd in <20s.

## Explicit non-goals
- Multi-region active-active. We're single-region primary with read replicas.
  Cross-region is a v2 conversation.
- Sub-millisecond latency. If a caller needs that, they should cache.
