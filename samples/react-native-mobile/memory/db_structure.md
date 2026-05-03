# DB structure (local SQLite via op-sqlite)

## Tables

### trails
```
id              TEXT PRIMARY KEY     -- ULID generated client-side
name            TEXT NOT NULL
description     TEXT
distance_m      REAL NOT NULL DEFAULT 0
ascent_m        REAL NOT NULL DEFAULT 0
bbox_min_lat    REAL, bbox_min_lon REAL, bbox_max_lat REAL, bbox_max_lon REAL
source          TEXT NOT NULL        -- 'imported' | 'recorded' | 'shared'
created_at      INTEGER NOT NULL     -- epoch ms
updated_at      INTEGER NOT NULL
deleted_at      INTEGER              -- soft delete; nullable
dirty           INTEGER NOT NULL DEFAULT 0
conflict        INTEGER NOT NULL DEFAULT 0
remote_rev      INTEGER              -- server revision last seen
```
Indexes: `(updated_at)`, `(dirty) WHERE dirty=1`, `(deleted_at) WHERE deleted_at IS NULL`.

### waypoints
```
id              TEXT PRIMARY KEY
trail_id        TEXT NOT NULL REFERENCES trails(id) ON DELETE CASCADE
seq             INTEGER NOT NULL     -- order along trail
lat             REAL NOT NULL
lon             REAL NOT NULL
elev_m          REAL
recorded_at     INTEGER              -- only set for recorded tracks
```
Indexes: `(trail_id, seq)`. We do NOT index `(lat, lon)` — for proximity queries we use the bbox on `trails` and load waypoints lazily.

### downloads (offline tile packs)
```
id              TEXT PRIMARY KEY
region_name     TEXT NOT NULL
bbox_*          REAL                 -- 4 cols
size_bytes      INTEGER
tile_count      INTEGER
status          TEXT NOT NULL        -- 'pending' | 'downloading' | 'ready' | 'failed'
progress        REAL DEFAULT 0       -- 0..1
mbtiles_path    TEXT                 -- absolute path on device
created_at      INTEGER, updated_at INTEGER
```

### outbox
```
id, op, payload (JSON TEXT), attempts, next_retry_at, last_error
```

## Sync strategy
- Pull: `GET /sync?since={lastRev}` returns rows newer than the cursor. We apply them in a single transaction and update `lastRev` only on success.
- Push: `POST /sync` with all rows where `dirty=1`. Server returns `{ accepted: [ids], conflicts: [{id, serverRow}] }`.
- Conflict resolution: last-write-wins by `updated_at`. The server is authoritative on tie.
- Tombstones: deletes set `deleted_at` and `dirty=1`. After server ack, rows are vacuumed locally on a 7-day schedule.
- We never run sync on a metered connection unless the user is in the foreground and explicitly tapped sync.
