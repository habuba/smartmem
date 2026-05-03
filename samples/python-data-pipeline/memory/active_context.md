# Active context

## Now
- Fixing late-arriving fact rows in `pricing_daily`. Vendor Bloomberg-feed sometimes posts T-3 corrections after our 06:00 UTC load. Currently dropping them silently because the dbt incremental filter is `loaded_at >= dateadd(day, -1, current_date)`. Widening the window to 5 days behind a `is_correction` flag.
- DAG `vendor_csv_ingest` flaky on Mondays — S3 listing returns 0 keys for ~30s after weekend batch. Added retry with exponential backoff in T-044.

## Open threads
- Snowflake credit burn up 22% MoM. Suspect the hourly `vendor_pricing_rt` materialized view is over-refreshing. Need to profile before next billing cycle.
- dbt test coverage on `marts/` is 41%. Target 80% by end of Q2.
- `airflow-providers-snowflake` 5.7 has a connection-leak bug; pinned to 5.6.1 until 5.8 ships.

## Recently decided
- 2026-04-28 — Move from CSV to Parquet for the FX-rates feed once vendor confirms support (Q3). Decision in `decisions.md`.
- 2026-04-15 — Stop snapshotting `dim_instrument`; use SCD2 in dbt instead. Migration done.
- 2026-04-02 — Adopt `ruff` (replaced `flake8` + `isort` + `black`). 3x faster on CI.
