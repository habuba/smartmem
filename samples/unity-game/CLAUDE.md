# voidrun

2-4 player co-op top-down roguelike. Procedural levels, server-authoritative sim, Steam target.

## Memory pointers
@memory/MEMORY.md
@memory/active_context.md

## Rules
- Unity 6000.0 LTS only. Don't suggest APIs deprecated in 2022.x.
- All tunable content is a ScriptableObject. No magic numbers in MonoBehaviours.
- Server-authoritative. Clients predict, server reconciles. Never trust client damage/loot.
- Deterministic sim: use `Game.Core.DetRng` seeded from session seed. No `UnityEngine.Random` in gameplay code.
- Avoid `Update()` when an event or coroutine works. Profile before adding per-frame work.
- Memory is written only by `memory-finalizer`. Other agents emit `MEMORY_NOTES:` blocks.
- Before touching networking, read `memory/architecture.md` and `memory/decisions.md` (host migration is load-bearing).
- Before adding content, read `memory/content_structure.md` — SO catalogs have a layout.
- Assembly boundaries are real. `Game.Content` must not reference `Game.Net`. Check the asmdef before adding `using`.
- Addressables groups are split for patch size. New content goes in the matching group, not the default.
- Steam build: IL2CPP, .NET Standard 2.1, Windows x64 only for now.
- Don't bump Mirror without reading the host migration notes in decisions.md — we patched it.
