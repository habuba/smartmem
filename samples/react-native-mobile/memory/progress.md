# Progress

## Milestones

### M0 — Spike (2026-01)
- Proved offline tile rendering with MapLibre + PMTiles on R2.
- Decided RN over Flutter (team familiarity, larger native module ecosystem).

### M1 — MVP internal (2026-02 → 2026-03)
- Auth (passkeys + email magic link).
- GPX import + trail list + trail detail.
- Map screen with live location.
- Basic recording (foreground only).
- Internal TestFlight; ~15 testers.

### M2 — Background recording + sync (2026-04)
- Background location task on iOS and Android.
- Sync engine + outbox + LWW conflict handling.
- Offline tile pack downloader.
- Migrated to op-sqlite, MapLibre, Zustand.
- Adopted New Architecture (RN 0.76).

### M3 — v1.0 public (target 2026-05-15)
- Hardening pass on background location (in progress).
- Crash-free ≥ 99.5% goal.
- App Store + Play Store submissions.
- Marketing site live at trailmate.app.

### M4 — v1.1 (target 2026-06)
- Friend sharing via deep links + web fallback.
- Elevation profile with Skia.
- Weather overlay (Pro).

### M5 — v2 (target Q4 2026)
- Watch companions (Apple Watch first, Wear OS fast-follow).
- Heart rate from Bluetooth sensors.
- Possible CRDT migration if conflict reports warrant it.

## KPIs to date (internal beta)
- Crash-free sessions: 98.7% (target 99.5%).
- Cold start p50: 1.6s on iPhone 12; 2.1s on Pixel 6.
- Recording battery: 11%/hr screen-off (target ≤ 8%).
- DAU/MAU among testers: 0.42.
