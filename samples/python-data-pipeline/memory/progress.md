# Progress

## 2026-Q2 (in progress)
- Late-arrival handling overhaul (T-041) — in flight
- dbt test coverage push to 80% (T-046)
- Parquet pilot for FX feed (T-047)

## 2026-Q1 shipped
- 2026-03-30 — `freeze_eod` DAG in prod, T+1 immutable snapshot for reg reporting.
- 2026-03-15 — ICE vendor onboarded as 3rd source. Vendor priority rule live.
- 2026-02-28 — Great Expectations on RAW layer; blocks bad files from reaching staging.
- 2026-02-10 — Snowflake cost monitor + 80% Slack alert. Burn down from $9.4k to $6.2k/mo.
- 2026-01-20 — Migrated to Airflow 2.9 / MWAA from self-hosted 2.6. Removed an entire ops surface.

## 2025 highlights (for context)
- 2025-Q4 — Initial pipeline went live: Bloomberg + Refinitiv -> Snowflake -> 3 marts.
- 2025-Q3 — Architecture decided, vendor contracts signed.

## Known debt
- `dags/common/sensors.py` has a 200-line custom S3 sensor that should become a provider PR upstream.
- `int_pricing_reconciled` is the single biggest model (12min). Candidate for incremental partitioning by month.
- Test fixtures in `tests/fixtures/` are 400MB; should move to git-lfs or generate on the fly.
