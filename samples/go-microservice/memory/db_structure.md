# DB structure

Postgres 15. Schema `ledger`. All amounts in minor units (BIGINT), no floats.

## Tables

### `ledger.account`
```
account_id      UUID PRIMARY KEY
currency        CHAR(3) NOT NULL              -- ISO 4217
kind            TEXT NOT NULL                 -- 'asset' | 'liability' | 'equity' | 'revenue' | 'expense'
created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
metadata        JSONB NOT NULL DEFAULT '{}'
```
Small (~10M rows steady state). No partitioning. Index on `(kind, currency)`.

### `ledger.ledger_entry`  (append-only, partitioned)
```
entry_id        UUID NOT NULL
posted_at       TIMESTAMPTZ NOT NULL          -- partition key
account_id      UUID NOT NULL REFERENCES ledger.account
amount          BIGINT NOT NULL               -- signed minor units; sum across legs of a txn = 0
currency        CHAR(3) NOT NULL
txn_id          UUID NOT NULL                 -- groups legs of one PostEntry call
leg_index       SMALLINT NOT NULL
prev_hash       BYTEA NOT NULL                -- sha256 of prior entry for this account
hash            BYTEA NOT NULL                -- sha256(prev_hash || canonical_json(this))
metadata        JSONB NOT NULL DEFAULT '{}'
PRIMARY KEY (entry_id, posted_at)
```
**Partitioned by RANGE(posted_at)**, monthly partitions. New partition created
by cron 7 days before month rollover. Partitions older than 18 months are
detached and archived to S3 Parquet, then dropped.

Indexes (on each partition, created via CREATE INDEX ... ON PARENT propagation):
- `(account_id, posted_at DESC)` — primary read pattern (ListEntries, GetBalance)
- `(txn_id)` — for fetching all legs of one transaction

No UPDATE, no DELETE permissions granted to the app role. Enforced at DB level.

### `ledger.idempotency_key`
```
key             TEXT PRIMARY KEY              -- caller-supplied
txn_id          UUID NOT NULL                 -- the entry this resolved to
created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
```
TTL job deletes rows older than 24h nightly. Lookup is the hot path on writes —
PK index is sufficient.

### `ledger.outbox_event`
```
event_id        BIGSERIAL PRIMARY KEY
txn_id          UUID NOT NULL
payload         BYTEA NOT NULL                -- protobuf-encoded ledger.entry.committed
created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
published_at    TIMESTAMPTZ                   -- NULL until relay publishes
```
Index on `(published_at) WHERE published_at IS NULL` — partial, keeps the
relay's poll query cheap as the table grows.

## Partition pruning
`pg_partman` manages creation; a custom job handles archival. Pruning a
partition is a metadata-only `ALTER TABLE ... DETACH PARTITION` followed by
`COPY ... TO PROGRAM 'aws s3 cp -'`. <5min for a 200GB partition (NFR-CAP-1).
