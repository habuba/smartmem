# progress

## Milestones

- **2025-09-01** — Project kickoff. Pre-production, prototype in Unity 2022.
- **2025-11-15** — Vertical slice: 1 biome, 5 enemies, 3 weapons, 1 boss. Single-player only.
- **2025-12-20** — Migrated to Unity 6 LTS. Caught early before content volume made it painful.
- **2026-01-10** — Mirror integration. First successful 4-player session (LAN).
- **2026-02-01** — Snapshot codec replaces SyncVars. Bandwidth dropped 6x.
- **2026-02-20** — Procedural level gen first pass. Constraint-sat chunk picker.
- **2026-03-05** — Netcode decision locked (Mirror, see decisions.md).
- **2026-03-15** — All 4 biomes blockmesh + first-pass enemies. Internal alpha 1.
- **2026-04-01** — Host migration working end-to-end (with caveats, see active_context.md).
- **2026-04-15** — Internal alpha 2. ~25 testers, 200 sessions. Crash-free rate 98.4%.
- **2026-04-22** — Linux v1 dropped, scope locked.

## Up next
- **2026-05-15** target — Closed alpha (Steam internal branch, ~200 testers).
- **2026-07-01** target — Beta.
- **2026-09-15** target — v1.0 ship.

## Health
- Crash-free sessions: 98.4% (target 99.5% by beta).
- Desync-ended sessions: 3.1% (target <2% by beta — see T-042).
- Sim tick p99: 1.4ms (budget 1.0ms — see T-045).
- Bandwidth p95: 24 KB/s up (budget 30, comfortable).
