# Active context

## Now
Hardening the recording flow before the v1.2 TestFlight on 2026-05-10.

## Open threads
- iOS background location stops after ~8 minutes when the screen is locked and the user isn't moving fast. Investigating significant-change vs continuous updates trade-off. Current hypothesis: iOS is suspending the background task because our `desiredAccuracy: Best` plus low motion gets classified as "stationary" and the OS reclaims the runtime. Plan: switch to `BestForNavigation` only while `speed > 0.5 m/s`, fall back to significant-change otherwise, and keep a silent audio session as a last-resort keepalive (controversial — App Review may flag).
- Android 14 foreground service notification is showing the wrong icon on Samsung devices (white square). Works on Pixel. Suspect Samsung's One UI strips tinted notification icons that aren't pure alpha. Need to ship a separate `ic_notification.png` with hard alpha, not the adaptive one.
- op-sqlite throws `database is locked` intermittently when the sync engine writes during a heavy GPX import. We're using a single connection but the import streams thousands of waypoints in one transaction. Likely solution: chunk the import into 500-row batches and yield between them.
- Sentry release health is reporting a 1.2% crash-free regression on 1.1.3 vs 1.1.2. Top crash is a NPE in MapLibre's annotation manager — filed upstream, no repro yet locally.

## Recently decided
- 2026-04-28: Bumped to RN 0.76 + new arch. Pulled the trigger after MapLibre 11.5 added Fabric support.
- 2026-04-22: Replaced Redux Toolkit with Zustand. -32 KB bundle, -800 LOC of boilerplate.
- 2026-04-15: Moved from expo-sqlite to op-sqlite. ~3x faster bulk insert.
- 2026-04-10: Migrated from react-native-maps (Google/Apple) to MapLibre GL Native.

## Not yet decided
- Whether to ship Apple Watch companion in v2 or punt to v3. Depends on whether HealthKit integration lands by July.
- Pricing model for Pro: monthly + annual, or annual-only with a 14-day trial.
