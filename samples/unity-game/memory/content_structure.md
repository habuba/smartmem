# content_structure

All content is ScriptableObjects under `Assets/_voidrun/Content/`. Naming: `{Type}_{Id}.asset`.

## Enemy catalog
`Content/Enemies/Enemy_*.asset` — `EnemyDefinition` SO.
Fields: id (stable string), displayName, prefab (AssetReference), hpCurve (AnimationCurve over run-difficulty), damageStat, behaviorTreeRef (SO), lootTableRef, biomeTags[], spawnWeight.

Catalog: `EnemyCatalog.asset` aggregates all definitions. Loaded at boot, indexed by id. Never reference enemies by `Resources.Load` or hard prefab ref — always go through catalog.

## Weapon catalog
`Content/Weapons/Weapon_*.asset` — `WeaponDefinition` SO.
Fields: id, prefab, fireMode (enum: hitscan/projectile/beam/charge), baseDamage, fireRate, magazine, reloadTime, projectileSO (nullable), modSlots (int 0-3), rarity.

Mods are separate SOs (`WeaponModDefinition`) applied at runtime; mod application is pure-functional `(WeaponDef, Mod[]) -> WeaponRuntimeStats`. Cached per (weapon, modSet) hash.

## Loot tables
`Content/Loot/Loot_*.asset` — `LootTable` SO. Weighted entries: `{ itemRef, weight, minDifficulty, maxDifficulty, conditions[] }`.
Rolled with `DetRng[loot]` seeded from `(sessionSeed, sectorIndex, killCount)` so loot is reproducible across host migration.

## Level chunk pool
`Content/Chunks/Chunk_<biome>_*.prefab` (in `_Sectors/` source scenes, baked into addressables).
Each chunk has a `ChunkMetadata` component: connector points (N/S/E/W), tileset id, difficulty band, tags (combat/loot/boss/transition).

Level gen (`Game.Gameplay.LevelGen`) picks chunks via constraint satisfaction: connector match + biome filter + tag budget per sector. Backtracks on dead-end. Seeded by `DetRng[levelgen]`.

## Relic catalog
`Content/Relics/Relic_*.asset` — passive effect, hooks into sim event bus. ~120 entries at v1. Stacking rules declared on SO (none/additive/multiplicative/unique).
