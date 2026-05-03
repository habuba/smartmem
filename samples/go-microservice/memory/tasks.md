# Tasks

## Open
- [ ] T-012 (2026-04-20) Static consumer-group membership for outbox-relay; drop
      session.timeout.ms to 10s. Verify with chaos pod-kill test.
- [ ] T-014 (2026-04-21) Add Prom alert on `pg_stat_replication.sync_state != 'sync'`
      for the named standby. Re-verify Cloud SQL HA config.
- [ ] T-015 (2026-04-22) Spike: per-account incremental balance refresh via
      triggers vs. Redis projection. Decision doc by end of sprint.
- [ ] T-018 (2026-04-25) Dry-run partition-pruning job against staging clone
      of prod. Capture timing, verify S3 Parquet output is queryable from Athena.
- [ ] T-019 (2026-04-28) Streaming `VerifyChain` RPC with checkpointing. Current
      impl OOMs on accounts > ~5M entries.
- [ ] T-021 (2026-05-01) Bump Go to 1.23.x patch release; re-run load test to
      confirm no regression on NFR-LAT-1.

## Done
- [x] T-011 (2026-04-18) Outbox poll interval 100ms -> 50ms during deploys.
- [x] T-010 (2026-04-15) Rejected `notes` field proposal; documented metadata schema.
- [x] T-009 (2026-04-10) Migrated all hand-rolled queries in `service/` to sqlc.
- [x] T-008 (2026-04-02) Hash chain fuzz target; ran 24h, no findings.
- [x] T-007 (2026-03-25) PartitionByMonth for `ledger_entry` + pg_partman config.
