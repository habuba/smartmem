# Commands

## Daily dev loop
```
ruff check .
ruff format .
pytest -q
```

## dbt
```
cd transform
dbt deps                                  # after pulling
dbt run --select stg_bloomberg__pricing+  # build a model and downstream
dbt test --select state:modified+         # only changed
dbt build --select tag:daily              # full daily prod-equiv run
dbt docs generate && dbt docs serve       # local docs
```

## Backfill
```
python scripts/backfill.py \
  --vendor bloomberg --feed pricing \
  --start 2026-04-01 --end 2026-04-15 \
  --dry-run
# remove --dry-run when ready. Script is idempotent (MERGE).
```

## Reconcile (compare our marts vs vendor source-of-truth)
```
python scripts/reconcile.py --date 2026-04-30 --tolerance 0.01
```

## Airflow (local)
```
make dev               # docker-compose up airflow + localstack + sf-mock
make airflow-logs DAG=vendor_csv_ingest
```

## Deploy
- Merge to `main` -> GitHub Actions auto-deploys DAGs + dbt manifest.
- Schema migration: manual `make migrate-prod` (intentional gate, requires approval).

## On-call
- Page ack: `/pd ack` in #data-platform.
- Pause a DAG: Airflow UI or `airflow dags pause <id>` via the bastion.
