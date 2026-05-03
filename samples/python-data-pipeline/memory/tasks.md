# Tasks

## Open
- [ ] T-041 (2026-04-22) Widen late-arrival window in `int_pricing_reconciled` from 1 to 5 days. Add `is_correction` derivation test.
- [ ] T-044 (2026-04-25) Add exponential backoff to `vendor_csv_ingest` S3 sensor (Monday-morning empty-listing bug).
- [ ] T-045 (2026-04-26) Profile `vendor_pricing_rt` MV refresh cost. Decide: drop, throttle, or accept.
- [ ] T-046 (2026-04-28) Raise dbt test coverage on `marts/` from 41% to 80%. Generic tests first, then singular.
- [ ] T-047 (2026-04-30) Pilot Parquet ingestion for FX feed (vendor confirms support 2026-Q3).
- [ ] T-048 (2026-05-01) Document `freeze_eod` recovery procedure in runbook (was tribal knowledge).
- [ ] T-049 (2026-05-02) Migrate off `airflow-providers-snowflake` 5.6.1 once 5.8 ships.

## Done
- [x] T-040 (2026-04-15) SCD2 in dbt for `dim_instrument`, retire snapshot. Backfill verified.
- [x] T-039 (2026-04-12) Adopt ruff, remove black/isort/flake8. CI 3x faster.
- [x] T-038 (2026-04-08) Add Great Expectations checks on RAW layer for null-rate + range.
- [x] T-037 (2026-04-02) Cost monitor + Slack alert at 80% of $8k Snowflake budget.
