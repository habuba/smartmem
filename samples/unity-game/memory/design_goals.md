# design_goals

## Feel
- 60Hz fixed sim tick. Render decoupled. Input sampled at render rate, applied at next sim tick.
- Damage numbers, hit flash, screen shake — all driven by sim events, never client-only guesses (avoids "I hit it but it didn't die" desync feel).

## Readability
- Top-down camera, fixed 30deg pitch (Cinemachine). Player silhouettes always readable against floor.
- Enemy telegraphs ≥400ms before damaging frame. No hidden one-shots.

## Performance budget
- 1ms sim per tick budget on host (4 players, ~80 active enemies).
- 4ms render budget on client mid-tier (GTX 1060 / Steam Deck).
- 250 MB peak managed heap. No GC alloc in hot loops — pool everything.

## Networking
- Host migration must succeed >95% of attempts. Loss of host ≠ loss of run.
- Bandwidth ceiling 30 KB/s up per client at p95.

## Content
- Adding a new weapon = 1 SO + 1 prefab + 1 addressable entry. No code change.
- Adding a new biome = chunk pool + tileset + boss SO. ~1 designer-week.
