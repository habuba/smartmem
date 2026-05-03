# Product context

## Who calls us
- **payments-svc** — writes a 2-leg entry per captured charge. ~3.5k rps peak.
- **wallet-svc** — writes transfers between user wallets. ~800 rps peak.
- **treasury-svc** — writes operator-initiated adjustments. <10 rps, manual review.

## Who reads from us
- **reporting-svc** — Kafka subscriber, builds OLAP rollups in ClickHouse.
- **fraud-svc** — Kafka subscriber, scores entries within 200ms of commit.
- **support-tools** — gRPC `GetEntries` for CS agents looking up disputes.

## SLAs we owe
- Write availability: 99.95% monthly. Read: 99.9%.
- Write p99 latency: 30ms (see NFR-LAT-1).
- Event publish lag: p99 < 500ms from commit to Kafka.
- Zero data loss tolerance — durability is non-negotiable, latency is negotiable.

## What changes for users when we ship something
Nothing visible. ledgerd is internal infrastructure. The product impact is felt
indirectly: faster fraud decisions, faster CS lookups, accurate end-of-day reports.
