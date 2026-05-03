# Design goals

## Offline-first
The phrase is overused. Concretely: every screen renders fully with airplane mode on, given that the user has previously downloaded the relevant content. Network calls are *enrichment* (e.g. fresh weather, social metadata) and must degrade silently — never a blocking spinner, never an error toast for "failed to fetch" when the offline data is sufficient.

## Low battery
Recording a 6-hour hike must cost less than 50% battery on a 3-year-old phone. Implications:
- GPS sample rate adapts to speed (1 Hz when moving > 2 m/s, 0.2 Hz when stationary).
- Map redraws only when the user pans or the position moves > 5 m.
- No polling. Server pushes via APNs/FCM silent notifications when something changes.
- Sentry session sampling is 10% in production, not 100%.

## No surprise data use
- Tile downloads are gated behind a confirm dialog showing MB and a "wifi only" toggle (default on).
- Background sync respects the OS data-saver setting.
- We do not preload "you might also like" content.

## Predictable performance
- 60 fps scroll on the trail list with 500+ items (FlashList, not FlatList).
- Map gesture latency < 16 ms (measured on Pixel 6).
- No JS-thread work > 50 ms on a user-visible interaction. We use the perf monitor in dev and Reassure for regressions.

## Accessibility
- Dynamic type respected on all text. Map controls have 44x44 hit targets minimum.
- VoiceOver labels on every interactive element. Map has a "describe surroundings" action that reads nearest trail name + distance.
