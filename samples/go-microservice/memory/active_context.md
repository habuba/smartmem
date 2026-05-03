# Active context

## Now
- Investigating Kafka rebalance storm during deploy rollouts. Each rolling
  restart of ledgerd triggers a consumer-group rebalance on the outbox-relay
  side, and we're seeing publish lag spike to ~8s p99 for ~2min after every
  rollout. NFR-EVT-1 budget is 500ms — currently violated during deploys only.
- Hypothesis: `session.timeout.ms` is too high (45s default) and we're not
  using static membership. Plan: set `group.instance.id` from the pod name and
  drop session timeout to 10s. Need to confirm static membership behaves
  during actual pod replacement, not just restart.
- Side thread: GetBalance materialized view refresh is taking 90s for the
  hottest 5% of accounts, blowing the 30s freshness target. Considering
  per-account incremental refresh via triggers vs. switching to event-sourced
  balance projection in Redis.

## Open threads
- T-014: confirm sync replica is actually sync. Last incident review showed
  one async replica had been promoted in a previous failover drill — need to
  re-verify Cloud SQL config and add an alert if `pg_stat_replication.sync_state`
  drifts from `sync` for the standby.
- partition-pruning job has never actually run in prod (we're 14 months in).
  T-018 tracks dry-run before month 18.
- `ledgerctl verify-chain` is O(n) per account and unusable for the 200M-entry
  accounts. Need a checkpointed/streaming version.

## Recently decided
- 2026-04-28: Switch outbox poll interval from 100ms to 50ms during deploys
  via SIGUSR1 handler. Mitigation, not fix, for the rebalance storm.
- 2026-04-22: GetBalance for cold accounts will compute on-the-fly indefinitely.
  Caching cold accounts is wasted memory.
- 2026-04-15: Reject the proposal to add a `notes` text field on `ledger_entry`.
  PII risk + index bloat. Use `metadata` JSONB with a documented schema instead.
