# System patterns

## Idempotent load (Snowflake MERGE)
Every raw -> staging step uses MERGE keyed on `(vendor, feed, business_date, instrument_id)`. File-hash captured in `_meta_file_hash` column for audit. Re-running a DAG instance is a no-op.

## Watermark pattern
Each ingest DAG reads `ops.ingest_watermark` for `(vendor, feed)` -> last successful business_date. Writes new watermark only after staging + GE validation pass. Failed runs leave watermark untouched, so next run re-attempts cleanly.

## Late-arrival reconciliation
`intermediate/int_pricing_reconciled.sql` window-functions over `(instrument_id, business_date)` ordered by `loaded_at DESC` and picks latest. `is_correction = (row_number > 1)`.

## Retry policy
- DAG-level: retries=2, retry_delay=5min, exponential backoff.
- Task-level overrides for SFTP sensors: retries=5, retry_delay=2min (vendors are flaky).
- dbt run: no Airflow retry (dbt has its own state); failures page immediately.

## Secrets
Never in code. Never in Airflow Variables. Only in AWS Secrets Manager, accessed via `SecretsManagerBackend` connection lookup.

## Naming
- Snowflake: `SCREAMING_SNAKE` for tables, `snake_case` for columns.
- dbt models: `stg_<vendor>__<feed>`, `int_<domain>_<purpose>`, `fct_<grain>` / `dim_<entity>`.
- Airflow DAG ids: `<domain>_<verb>` e.g. `pricing_freeze_eod`.

## Anti-patterns we hit and abandoned
- Truncate-and-reload: lost late corrections. Replaced with MERGE.
- dbt snapshots for SCD2: too slow at our row count (40M+/day). Replaced with explicit `valid_from`/`valid_to` in incremental model.
