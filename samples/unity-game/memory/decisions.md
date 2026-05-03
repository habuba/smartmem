# decisions

## 2026-03-05 — Mirror over Netcode for GameObjects
**Context:** Need a netcode lib for 4-player peer-hosted co-op with host migration.
**Decision:** Mirror 89.x.
**Reason:** Simpler debug visibility (readable wire format, NetworkBehaviour inspector shows live state). More mature host migration story — NGO host migration was still preview at eval time. Larger sample base for our exact use case (peer-host PvE roguelike). NGO's snapshot system is opinionated in ways that fight our hand-rolled bitpacker.
**Cost:** Mirror's Transport abstraction is messier; we picked KCP transport and don't intend to swap.

## 2026-03-12 — Hand-rolled snapshot codec, not Mirror's SyncVar
**Context:** SyncVar reflection overhead + per-field message granularity is too chatty for 30 enemies × 60Hz.
**Decision:** `Game.Net.SnapshotWriter` bitpacks one message per tick per client.
**Reason:** Bandwidth budget (30 KB/s up) doesn't survive SyncVar. Codec handwritten = 6x smaller payload.
**Cost:** Every new networked field needs a codec entry. Caught one bug already (T-042).

## 2026-03-20 — IL2CPP, Windows x64 only at v1
**Context:** Cross-platform was on the table.
**Decision:** Win x64 only, Steam Deck via Proton.
**Reason:** Eliminates float determinism worries (we'd need fixed-point if cross-arch). IL2CPP-on-Linux toolchain pain not worth it for v1 user base.
**Revisit:** Native Linux + macOS post-v1 if Deck data shows demand.

## 2026-04-05 — Patched Mirror host migration timeout
**Context:** Default Mirror migration timeout (5s) caused false migrations on transatlantic spike.
**Decision:** Forked Mirror, bumped to 12s, added jitter window. Patch lives in `Packages/Mirror.patched/`.
**Reason:** Upstream PR pending. Don't bump Mirror without porting the patch.

## 2026-04-22 — Drop Linux v1 target
See active_context.md. Saves ~4 weeks. Proton coverage validated on Deck dev kit.
