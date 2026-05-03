# Tech context

## Versions
- Python 3.12.2 (pinned in `.python-version`)
- Airflow 2.9.1 (MWAA)
- dbt-core 1.7.8, dbt-snowflake 1.7.4
- Snowflake account: `acme-prod.us-east-1`
- pydantic 2.6, pandas 2.2, polars 0.20 (used in hot paths)
- pytest 8.1, pytest-cov 5.0
- ruff 0.4.2 (replaces black/isort/flake8)
- great-expectations 0.18

## Lint / format
```
ruff check .
ruff format .
```
CI fails on any ruff error. No exceptions; add to `ruff.toml` `ignore` if truly necessary, with comment.

## Test
```
pytest -q                          # unit
pytest tests/integration -q        # integration (requires AWS creds + mock Snowflake)
pytest --cov=ingest --cov=dags     # with coverage
```

## dbt
```
cd transform
dbt deps
dbt run --select state:modified+ --defer --state ./prod-manifest   # slim CI
dbt test
dbt build --select tag:daily
```

## Deploy
- Airflow: GitHub Actions on merge to `main` rsyncs `dags/` to MWAA S3 bucket.
- dbt: same workflow runs `dbt compile` + uploads compiled manifest as the new prod-manifest artifact.
- Schema migrations: Flyway, `migrations/V<n>__<desc>.sql`, applied via separate manual job (intentional gate).

## Local dev
- `make dev` spins docker-compose with localstack (S3) + Airflow + a Snowflake-mock service.
- `.env.example` documents required vars. Never commit `.env`.
