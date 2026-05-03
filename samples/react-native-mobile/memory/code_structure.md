# Code structure

```
trailmate/
├── app.config.ts              # Expo config, reads from env
├── eas.json                   # EAS profiles: development, preview, production
├── App.tsx                    # Root: providers, nav container, error boundary
├── src/
│   ├── ui/                    # Design system: Button, Text, Sheet, Toast, theme
│   │   ├── theme/             # tokens.ts, ThemeProvider, useTheme
│   │   └── components/
│   ├── features/
│   │   ├── map/               # MapScreen, MapLibre wrapper, layers, offline pack mgr
│   │   ├── trails/            # TrailListScreen, TrailDetailScreen, GPX import
│   │   ├── recording/         # RecordingScreen, location task, elevation calc
│   │   ├── sharing/           # share-link create + receive (deep link)
│   │   └── profile/           # Account, Settings, Downloads, About
│   ├── nav/                   # RootNavigator, TabNavigator, linking config
│   ├── stores/                # zustand: trailsStore, recordingStore, prefsStore, authStore
│   ├── db/
│   │   ├── connection.ts      # op-sqlite open + migrate on boot
│   │   ├── migrations/        # 001_init.sql, 002_add_outbox.sql, ...
│   │   └── repos/             # trailsRepo, waypointsRepo, downloadsRepo, outboxRepo
│   ├── sync/                  # engine.ts, conflict.ts, backoff.ts
│   ├── services/              # locationTask.ts (background), sentry.ts, gpx.ts
│   ├── lib/                   # pure utils: distance.ts, smoothing.ts, time.ts
│   └── types/                 # shared TS types, zod schemas
├── assets/                    # fonts, splash, icons
├── ios/ android/              # native projects (committed; we run dev builds)
└── __tests__/                 # vitest + RNTL; e2e in /e2e via Maestro
```

## Conventions
- One default export per file, named the same as the file. PascalCase for components, camelCase for everything else.
- Tests colocated as `*.test.ts(x)` next to the unit they test, except integration tests in `__tests__/`.
- No barrel files (`index.ts` re-exports). They wreck Metro tree-shaking and make grep harder.
