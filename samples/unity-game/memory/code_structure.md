# code_structure

## Assemblies (asmdef)
```
Assets/_voidrun/
  Code/
    Game.Core/        — sim, math, DetRng, ECS-lite components. No Unity refs beyond Vector2/3.
    Game.Content/     — ScriptableObject definitions + catalog loaders. Refs: Game.Core.
    Game.Net/         — Mirror NetworkBehaviours, snapshot codec, host migration. Refs: Game.Core, Game.Content.
    Game.Gameplay/    — MonoBehaviours that bridge sim ↔ scene. Refs: all above.
    Game.UI/          — UI Toolkit panels, HUD, lobby. Refs: Game.Content (read-only), Game.Core (read-only).
    Game.Boot/        — bootstrap scene loader, addressables init, Steam init. Refs: all.
    Game.Editor/      — editor tooling, SO validators, build pipeline. Editor-only.
    Game.Tests.Play/  — playmode tests.
    Game.Tests.Edit/  — editmode tests, sim determinism harness.
```

Reference rule: arrows go down only. `Game.Core` references nothing internal. `Game.Content` must NOT reference `Game.Net`.

## Scenes
- `Boot.unity` — single entry. Loads addressables catalog, Steam init, then additive-loads `MainMenu`.
- `MainMenu.unity` — lobby, run config, meta progression UI.
- `Run.unity` — empty arena. Sectors stream in additively from addressables.
- `_Sectors/Sector_*.unity` — chunk source scenes, never loaded directly at runtime; baked into addressables.

## Addressables groups
- `core` — built into player. Boot, MainMenu assets, shared shaders.
- `content_weapons` — weapon SOs + prefabs + VFX. ~40 MB.
- `content_enemies` — enemy SOs + prefabs + anims. ~80 MB.
- `content_biomes_<n>` — per-biome chunk scenes + tilesets. Streamed on biome enter.
- `audio_music` — remote-only group, downloaded on demand.

Patch strategy: bundle naming = `{group}_{contentHash}`. Steam depot diff stays minimal because biome groups don't churn together.
