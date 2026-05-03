# Design goals

## Idempotent loads
Every load is keyed by `(vendor, feed, business_date, file_hash)`. Re-running a DAG must not duplicate rows. Enforced via Snowflake MERGE on natural key + `dbt incremental` with `unique_key`.

## Late-arrival tolerance
Vendors send corrections up to T-5. Pipeline must accept and re-process without manual intervention. `is_correction` flag preserves audit trail; downstream marts use latest-version-wins.

## Cost ceiling
Snowflake compute budget: $8k/month. Current run: $6.2k. Hard cap enforced via resource monitor + Slack alert at 80%.

## Failure isolation
One vendor's bad file must not block other vendors' loads. DAGs are per-vendor; shared dbt run happens after all vendor loads succeed-or-skip.

## Schema evolution
- Additive changes (new column): no version bump.
- Breaking changes (rename, drop, type change): new versioned view (`pricing_daily_v2`), 30-day overlap.

## Observability
- Every DAG emits OpenLineage events to Marquez.
- Row counts + null rates logged to `ops.dag_run_metrics`.
- dbt test failures page on-call only if severity=error; warn-level goes to Slack.

## Non-goals
- Sub-minute latency (use the Kafka pipeline).
- Multi-region failover (single us-east-1 deployment is acceptable).
