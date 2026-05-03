# Project brief

trailmate is a mobile app for hikers who spend most of their trip out of cell range. The product promise is simple: open the app on a mountain with no signal, see where you are on a real map, follow a route you imported the night before, and record your track for later.

## Scope
- Vector map rendering with offline tile packs scoped to a downloaded region.
- GPX import (file-share intent on Android, share-extension on iOS) and export.
- Route following with off-route alerts (haptic + audio cue).
- Track recording with elevation, distance, moving time, pace.
- Trail library synced across devices for the same account.
- Friend sharing of completed tracks via deep link.

## Out of scope (for v1)
- Turn-by-turn voice navigation.
- Social feed, comments, likes.
- In-app trail marketplace.
- Apple Watch / Wear OS companions (planned v2).

## Success metrics
- Crash-free sessions ≥ 99.5%.
- Cold start to interactive map ≤ 2.0s on iPhone 12 / Pixel 6.
- Battery drain during recording ≤ 8% per hour with screen off.
- ≥ 70% of users who start a recording finish it (vs abandon).
