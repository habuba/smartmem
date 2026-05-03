# Architecture

## Layers

```
UI (screens/components, React)
  ↓ reads / dispatches
Zustand stores (in-memory, persisted slices to MMKV)
  ↓ calls
Repos (src/db/repos/*) — only layer that touches SQLite
  ↓ uses
op-sqlite connection (single shared instance, opened on app start)

Sync engine (src/sync/*) — runs independently
  ↓ reads dirty rows from repos
  ↓ POSTs to backend, applies server diffs back via repos
Backend (Hono on Cloudflare Workers, Postgres via Neon)
```

## Data flow for a write
1. UI calls a store action, e.g. `trailsStore.rename(id, name)`.
2. Store calls `trailsRepo.update(id, { name, dirty: 1, updatedAt: now })`.
3. Repo writes to SQLite synchronously (op-sqlite is fast enough). Store reads back and updates its in-memory copy. UI re-renders. **This is the optimistic path.**
4. Sync engine wakes (debounced 2s, or on connectivity change). It reads `WHERE dirty = 1`, posts a batch, on 200 sets `dirty = 0`. On 4xx it marks `conflict = 1` and surfaces a banner.
5. On conflict, current rule is last-write-wins by `updatedAt`. We accept the loss for v1; CRDTs are a v2 problem.

## Offline queue
Mutations that need a server round-trip (e.g. share-link creation) go into an `outbox` table with `op`, `payload`, `attempts`, `nextRetryAt`. The sync engine drains it with exponential backoff capped at 30 min. On app start we kick the engine once.

## Why not Redux / Redux Toolkit Query
Zustand is 1 KB and has no provider boilerplate. RTK Query assumes a server-of-truth model that fights offline-first. We use TanStack Query only for the small set of screens that are genuinely server-driven (friend search, account settings).

## Module boundaries
- `src/features/*` is allowed to import from `src/db`, `src/stores`, `src/ui`. Not from another feature.
- Cross-feature communication goes through stores or events, never direct imports. Enforced by an eslint boundary rule.
