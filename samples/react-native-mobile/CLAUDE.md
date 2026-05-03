# trailmate

Offline-first hiking companion for iOS and Android. Map tiles, GPX import/export, route sharing with friends, recorded tracks with elevation. Built to work in the backcountry where there is no signal.

## Stack
- React Native 0.76 (new architecture: Fabric + TurboModules)
- Expo SDK 52 with development builds (not Expo Go — we need native modules)
- TypeScript strict
- Zustand for state, with persist middleware
- MapLibre GL Native for offline vector tiles
- op-sqlite for local persistence (faster than expo-sqlite, supports prepared statements)
- TanStack Query for server cache
- EAS Build / EAS Update for OTA
- Sentry for crash + perf

## Memory pointers
@memory/MEMORY.md
@memory/active_context.md

## Rules
- Offline-first. Every screen must render with zero network. Server is enrichment, never a dependency.
- Never block the JS thread on render. Heavy work goes through `InteractionManager.runAfterInteractions` or a worklet.
- All DB writes go through the repo layer in `src/db/repos/*`. No raw SQL in components or stores.
- All mutations are optimistic. Failures revert and surface a toast (see `system_patterns.md`).
- Errors that reach a user are toasts, not alerts. Alerts are reserved for destructive confirms.
- Do not import from `react-native-maps` — we migrated off (see decisions.md).
- Coordinates are stored as `(lat, lon)` doubles, not GeoJSON, in SQLite. GeoJSON only at the network/import boundary.
- Background location is `whenInUse` by default. `always` is a separate opt-in flow with a rationale screen — never request silently.
- Run `pnpm typecheck && pnpm test` before any PR. EAS builds run their own check but it's slow.
- Memory writes belong to `memory-finalizer` only. Other agents emit `MEMORY_NOTES:` blocks.
- Before non-trivial changes, read the relevant pointer from `memory/MEMORY.md`.
