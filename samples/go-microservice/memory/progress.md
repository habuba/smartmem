# Progress

## Milestones
- **2026-01-15** Project kickoff. Schema sketched on a whiteboard, agreed on
  append-only + transactional outbox + sqlc.
- **2026-02-01** First green `PostEntry` end-to-end in dev. No idempotency yet.
- **2026-02-20** Idempotency + hash chain landed. Fuzz target written.
- **2026-03-01** Partition-by-month migration applied to staging.
- **2026-03-10** Shadow traffic from payments-svc started — read-only, write
  results compared against legacy ledger. Zero divergences after 72h.
- **2026-03-20** First production write from payments-svc (1% canary).
- **2026-04-01** Ramped to 100% of payments-svc traffic. Legacy ledger frozen
  for new writes.
- **2026-04-10** wallet-svc cut over.
- **2026-04-18** treasury-svc cut over. ledgerd is now the sole source of truth.
- **2026-04-20** First post-cutover incident: Kafka rebalance storm during
  deploy. Lag spike, no data loss. Mitigation in T-011, real fix in T-012.

## Numbers (last 7d, prod)
- PostEntry rps: 4.1k avg, 5.8k peak
- Write p99: 22ms (budget 30ms)
- Read p99 GetEntry: 6ms (budget 10ms)
- Read p99 GetBalance: 41ms (budget 50ms)
- Outbox publish lag p99: 380ms steady, 8s during deploys (budget 500ms — see T-012)
- Availability: 99.98% (rolling 30d)

## Next milestone
- **2026-05-15 target** T-012 + T-014 + T-018 closed; first scheduled
  partition prune executed in prod.
