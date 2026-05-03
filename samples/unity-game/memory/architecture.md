# architecture

## Sim loop (host)
1. **Input gather** — collect inputs from all clients for tick T (buffer up to 6 ticks late).
2. **Simulate** — fixed 16.67ms step. Deterministic. Reads only `Game.Core` + `Game.Content` SOs.
3. **Snapshot** — diff against last acked snapshot per client. Quantize positions (16-bit fixed), bitpack flags.
4. **Send** — UDP unreliable for snapshots, reliable channel for spawn/despawn/loot-claim events.

## Client loop
1. **Predict** — apply local input immediately to local pawn (client-side prediction).
2. **Receive snapshot** — reconcile: rewind local pawn to acked tick, replay buffered inputs, blend if delta < threshold else snap.
3. **Interpolate** — render remote entities 100ms behind authoritative time for smooth motion.
4. **Render** — Cinemachine + URP. Effects play off sim events received this frame.

## Rollback (inputs only)
We rollback inputs, not full state. Cheaper than GGPO-style. Works because non-input gameplay (enemy AI, projectiles) is fully server-driven and never predicted client-side.

## Host migration
On host disconnect, peer with lowest player ID becomes new host. State transfers via last full snapshot every peer holds + reliable event log since that snapshot. New host re-seeds DetRng from `(sessionSeed, currentTick)` so procedural decisions stay deterministic post-migration.

## Determinism boundaries
- Sim uses `Game.Core.DetRng` (xoshiro256**, seeded per-tick).
- Float math is fine — we don't cross-platform sim, only Win x64. No fixed-point needed.
- VFX, audio, camera shake, UI tweens — all non-deterministic, client-local, never feed back into sim.
