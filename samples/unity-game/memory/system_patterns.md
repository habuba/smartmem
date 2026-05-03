# system_patterns

## SO-driven content
Every tunable lives on a ScriptableObject. Weapons, enemies, relics, status effects, loot tables, biome configs, even camera profiles. MonoBehaviours hold a reference to the SO and read from it. Designers never touch code to balance.

Validator: `Game.Editor.SOValidator` runs pre-build, fails the build if any SO has null required refs or out-of-range stats.

## Server-authoritative simulation
Damage, spawn, loot, death — all decided on host. Client sends intent ("I pressed fire at angle X"); host runs the projectile. Client visually predicts the muzzle flash but never the hit. Cheating surface = zero (peer host trusted by definition; no PvP so it doesn't matter).

## Deterministic RNG with seed sync
`Game.Core.DetRng` is xoshiro256**. One instance per system (loot, enemy AI, level gen) seeded as `hash(sessionSeed, systemId, tick)`. Never share an RNG across systems — debugging desyncs gets impossible.

Daily seed = `hash(date_utc)`. Recorded with run for replay/leaderboards.

## No Update() if event-driven works
Default to:
- `ITickable` interface registered with `SimWorld`, ticked at fixed step.
- UnityEvents / C# events for one-shot reactions.
- Coroutines for time-bounded sequences.

Use `Update()` only for input sampling and camera follow. PR reviewer rejects new `Update()` unless justified.

## Pooling
`Game.Core.Pool<T>`. All projectiles, VFX, damage numbers, enemy corpses. Zero `Instantiate` in gameplay loops. Pool sizes are SO-configured per content pack.

## Snapshot codec
Hand-rolled bitpacker in `Game.Net.SnapshotWriter`. Position quantized to 16-bit per axis (world is 1024x1024 units, 1/64 unit precision). Velocity 12-bit. State flags are bitfields. Avg snapshot 180 bytes for 4 players + 30 visible enemies.
