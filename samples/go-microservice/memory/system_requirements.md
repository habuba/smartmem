# System requirements

## Functional
- **FR-1** Accept `PostEntry` RPC with N legs (N≥2), validate sum-of-legs == 0.
- **FR-2** Reject duplicate `idempotency_key` within 24h window with `ALREADY_EXISTS`
  and return the original `entry_id`.
- **FR-3** Publish `ledger.entry.committed` Kafka event for every committed entry,
  partitioned by `account_id` of leg[0].
- **FR-4** Expose `GetEntry(entry_id)`, `ListEntries(account_id, time_range)`,
  `GetBalance(account_id, as_of)` read RPCs.
- **FR-5** Maintain hash chain: `entry.hash = sha256(prev_hash || canonical_json(entry))`
  per account.
- **FR-6** Support reversing entries via `PostReversal(original_entry_id, reason)`.
  Original stays; reversal is a new entry with inverted amounts.
- **FR-7** Daily cold-archive job moves entries older than 18 months to S3 Parquet.

## Non-functional
- **NFR-LAT-1** Write p99 < 30ms at 5k rps sustained (PostEntry, 2 legs).
- **NFR-LAT-2** Read p99 < 10ms for GetEntry, < 50ms for GetBalance.
- **NFR-DUR-1** RPO = 0. Synchronous replication to standby in same region.
  No write acknowledged until WAL is on standby disk.
- **NFR-DUR-2** RTO ≤ 60s for primary failover.
- **NFR-AVL-1** 99.95% monthly write availability. Maintenance windows excluded
  only if pre-announced 7 days prior.
- **NFR-EVT-1** Kafka publish lag p99 < 500ms commit-to-broker-ack. Outbox
  pattern; no in-process publish from the request path.
- **NFR-SEC-1** mTLS on all gRPC. SPIFFE identities. No password auth anywhere.
- **NFR-SEC-2** PII (account holder name, email) never in `ledger_entry`. Only
  opaque `account_id` UUIDs.
- **NFR-OBS-1** OTel traces on every RPC, sampled at 1% baseline, 100% on error.
- **NFR-OBS-2** Prometheus metrics: `ledgerd_write_duration_seconds` histogram
  with `le` buckets at 1,5,10,20,30,50,100,250,500,1000 ms.
- **NFR-CAP-1** Storage growth budget: 200GB/month at current rate. Partitioning
  must support pruning of old partitions in <5min.
- **NFR-COMP-1** SOX-relevant. All schema changes go through migration review.
  No direct DDL in production, ever.

## Out of scope
- Multi-currency conversion, FX rates, settlement netting.
