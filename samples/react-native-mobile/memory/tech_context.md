# Tech context

## Prereqs
- Node 20.x (use `fnm`/`nvm`), pnpm 9.
- Xcode 16, iOS 17 simulator. CocoaPods 1.15+.
- Android Studio Ladybug, JDK 17, Android SDK 35.
- EAS CLI: `pnpm dlx eas-cli@latest`. Logged in to the `trailmate` org.
- Maestro for e2e: `curl -Ls "https://get.maestro.mobile.dev" | bash`.

## Day-to-day
```bash
pnpm install
pnpm prebuild              # expo prebuild --clean if native deps changed
pnpm ios                   # = npx expo run:ios --device
pnpm android               # = npx expo run:android
pnpm start                 # metro only, if a dev build is already on the device
pnpm typecheck             # tsc --noEmit
pnpm lint
pnpm test                  # vitest + RNTL
pnpm test:e2e              # maestro test e2e/
```

## Builds
```bash
# Internal preview (TestFlight / Play internal track)
eas build --profile preview --platform all

# Production
eas build --profile production --platform all
eas submit --profile production --platform ios
eas submit --profile production --platform android

# OTA (JS-only changes; bumps no native version)
eas update --branch production --message "fix: off-route alert debounce"
```

## Sentry
Source maps and dSYMs upload happens in the EAS post-build hook (`eas-build-on-success.sh`). For a manual upload after a hotfix:
```bash
pnpm sentry-cli releases new "trailmate@$(node -p "require('./package.json').version")"
pnpm sentry-cli releases files "$RELEASE" upload-sourcemaps ./dist
pnpm sentry-cli releases finalize "$RELEASE"
```

## Env
`.env.local` (gitignored) holds `EXPO_PUBLIC_API_URL`, `SENTRY_AUTH_TOKEN`, `MAPLIBRE_TOKEN` (optional, for the demo tile server). CI uses EAS secrets.

## Known sharp edges
- After bumping any native dep: `pnpm prebuild` then re-run `pnpm ios`. Metro cache will lie otherwise.
- op-sqlite needs `pod install` after every clean. Wrapped in `pnpm pods` script.
- New Architecture is on. Any third-party lib without Fabric support is a non-starter — check before adding.
