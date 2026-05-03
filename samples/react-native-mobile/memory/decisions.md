# Decisions (ADR-lite)

## 2026-04-10 — Migrate from react-native-maps to MapLibre GL Native
**Context.** react-native-maps wraps Google Maps on Android and Apple Maps on iOS. Neither supports offline vector tiles in a way that survives App Store review (Apple Maps refuses entirely; Google's offline mode is a black box with no API). Our core promise is offline.
**Decision.** Adopt `@maplibre/maplibre-react-native`. Host our own tile server (PMTiles on Cloudflare R2) with OSM-derived tiles.
**Consequences.** We own tile freshness and styling. We avoid Mapbox's per-MAU pricing (would be ~$2k/mo at our projected scale). MapLibre's RN bindings are less polished — we accept some glue code. Cost: ~3 weeks of migration.

## 2026-04-15 — Replace expo-sqlite with op-sqlite
**Context.** Bulk inserts of GPX waypoints (10k+ rows) took 4-8 seconds with expo-sqlite. Users perceived the import as broken.
**Decision.** Move to op-sqlite (OP-Engineering's JSI-based wrapper).
**Consequences.** ~3x faster on bulk insert, prepared statements supported, sync API available for migrations. Adds a CocoaPods dependency. We lose Expo Go compatibility — already gone since we needed MapLibre.

## 2026-04-22 — Replace Redux Toolkit with Zustand
**Context.** Three engineers, ~30 slices, half of them just wrapped a single `useState`. RTK Query was being used for screens that don't have a server.
**Decision.** Zustand for client state, TanStack Query for the small set of genuinely server-driven screens.
**Consequences.** -32 KB bundle, -800 LOC. No Redux DevTools time-travel; we add Reactotron for the cases we need it. Migration done in one sprint.

## 2026-04-28 — Adopt React Native New Architecture (Fabric + TurboModules)
**Context.** RN 0.76 makes new arch the default. MapLibre 11.5 shipped Fabric support, which was our blocker.
**Decision.** Enable on both platforms, remove all bridge-based modules, audit third-party deps for compatibility.
**Consequences.** Better gesture latency on the map. Forced us to drop one library (`react-native-progress`, replaced with our own). Build times increased ~15%.

## 2026-05-01 — Last-write-wins for sync conflicts (deferred CRDTs)
**Context.** v1 ships in two weeks. Real CRDT (Yjs/Automerge) on SQLite is doable but 4-6 weeks of work and risk.
**Decision.** LWW by `updated_at`, server-authoritative on tie. Surface conflicts in UI as a banner; user can manually choose.
**Consequences.** Edge case: two devices offline, both edit same trail name, last-synced wins. Acceptable for hiking-app semantics. Revisit in v2 if user reports surface.
