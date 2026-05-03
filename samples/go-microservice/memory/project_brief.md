# Project brief

ledgerd is the append-only double-entry ledger for the platform. It owns the
canonical record of every credit and debit, exposes a gRPC write/read API, and
publishes a Kafka event for every committed entry so downstream services
(reporting, fraud, notifications) can react without polling Postgres.

## Why it exists
Before ledgerd, monetary state was scattered across the payments service, the
wallet service, and three reporting jobs that each ran their own SUM(amount)
query. Reconciliation drift hit ~$0.02/account/month — small per-row, large in
aggregate, and unauditable. ledgerd centralizes the writes, enforces double-entry,
and makes "what is the balance at time T" answerable from one source.

## What it is not
- Not a settlement engine. We record movement; settlement is a downstream job.
- Not a pricing or FX service. Amounts arrive pre-converted in minor units.
- Not a generic event bus. We publish only ledger events.

## Boundaries
- Upstream: payments, wallet, treasury (gRPC writers).
- Downstream: reporting, fraud, notifications (Kafka subscribers).
- Storage: Postgres 15 (primary), S3 (cold archive after 18 months).
