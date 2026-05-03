# Tasks

## Open
- [ ] T-042 (2026-04-29) Fix boss buff stack desync on host migration — `SnapshotWriter.WriteEntity` dirty flag for `BossBuffComponent.stackCount`
- [ ] T-043 (2026-04-30) Add full-snapshot fallback path on migration as defense-in-depth (8KB one-time cost acceptable)
- [ ] T-044 (2026-04-28) Lobby ready-check animation — designer mockup in Figma, animator handoff pending
- [ ] T-045 (2026-04-25) Profile sim tick on 4p+80 enemy stress test, current p99 1.4ms (budget 1.0ms)
- [ ] T-046 (2026-04-22) Replace `WeaponRuntimeStats` cache key with content hash, not array ref
- [ ] T-047 (2026-04-20) SOValidator: add range check on `EnemyDefinition.spawnWeight` (saw a 0.0 ship to internal build)
- [ ] T-048 (2026-04-18) Cinemachine 3.1 upgrade — test impulse sources still fire on sim events post-upgrade
- [ ] T-049 (2026-04-15) Steam Deck input remap profile — gyro aim opt-in
- [ ] T-050 (2026-04-12) Daily seed leaderboard backend — Steamworks leaderboards spike, unknowns around tie-break

## Done
- [x] T-041 (2026-04-22) Drop Linux build target, document Proton-on-Deck as supported path
- [x] T-040 (2026-04-15) Boss telegraph minimum bumped to 500ms across all bosses
- [x] T-039 (2026-04-10) Loot claim timer tuning, settled at 8s
- [x] T-038 (2026-04-05) Mirror 89 upgrade + host migration patch (see decisions.md)
- [x] T-037 (2026-03-28) Addressables group split — biomes are now per-group
