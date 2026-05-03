# UI structure

## Navigator tree
```
RootStack (native-stack)
├── Onboarding (modal, shown once)
├── Main (TabNavigator, bottom tabs)
│   ├── MapTab (native-stack)
│   │   ├── MapScreen                 [initial]
│   │   ├── OfflinePackScreen
│   │   └── LayerPickerScreen         (modal presentation)
│   ├── TrailsTab (native-stack)
│   │   ├── TrailListScreen           [initial]
│   │   ├── TrailDetailScreen
│   │   ├── GpxImportScreen           (modal)
│   │   └── RecordingScreen           (full-screen, hides tab bar)
│   └── ProfileTab (native-stack)
│       ├── ProfileScreen             [initial]
│       ├── DownloadsScreen
│       ├── SettingsScreen
│       └── AboutScreen
├── Auth (modal stack: SignIn, VerifyEmail)
└── ShareInbound (modal, deep-link target for trailmate://share/:id)
```

`linking` config exposes: `trailmate://trail/:id`, `trailmate://share/:token`, universal links on `trailmate.app/t/:id`.

## Key screens

- **MapScreen**: full-bleed MapLibre view. Top-right floating buttons: layers, locate-me, recenter. Bottom sheet (3 snap points: peek 80px, mid 40%, full 90%) with current track stats when recording, or "Start recording" CTA when idle. The map is mounted once for the app's lifetime — switching tabs hides it via `display: none`, never unmounts. Re-mounting MapLibre costs ~400 ms.
- **TrailListScreen**: FlashList of trails, filter chips (All / Imported / Recorded / Shared), search bar with debounce 250 ms. Empty state has a primary "Import GPX" CTA.
- **TrailDetailScreen**: hero map preview (static raster snapshot from cached tiles, not a live MapLibre instance — perf), stats card, elevation profile (Skia), action row (Follow, Share, Export, Delete).
- **RecordingScreen**: large stats (distance, duration, pace, elevation), pause/stop controls, lock-screen toggle. Survives backgrounding via the location task.
- **DownloadsScreen**: list of offline packs with size, region, last used. Long-press to delete.

## Theme system
- Tokens in `src/ui/theme/tokens.ts`: spacing (4/8/12/16/24/32), radii (sm/md/lg/full), color roles (`bg`, `bgElevated`, `fg`, `fgMuted`, `accent`, `danger`, `success`).
- Two palettes: `light`, `dark`. `useTheme()` returns the resolved palette + tokens. No hardcoded hex anywhere — eslint rule enforces.
- System-driven by default (`Appearance.getColorScheme()`), overridable in Settings.
- Typography: SF Pro on iOS, Inter on Android. 6 sizes, 3 weights. Line height baked into the token, never set ad-hoc.
