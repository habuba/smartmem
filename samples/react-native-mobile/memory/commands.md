# Commands cheat sheet

## Setup
```bash
pnpm install
pnpm prebuild              # only when native deps changed
pnpm pods                  # cd ios && pod install
```

## Run
```bash
pnpm ios                   # dev build on attached iPhone or simulator
pnpm android               # dev build on attached Android
pnpm start                 # metro only (dev build already installed)
pnpm start --reset-cache   # when Metro lies after a native bump
```

## Test / lint
```bash
pnpm typecheck
pnpm lint
pnpm test                  # unit + RNTL
pnpm test --watch
pnpm test:e2e              # maestro
pnpm test:perf             # reassure baseline diff
```

## DB
```bash
pnpm db:migrate:new <name> # scaffolds src/db/migrations/NNN_<name>.sql
pnpm db:reset              # wipes simulator app data + reinstalls
```

## Build / release
```bash
eas build --profile preview --platform all
eas build --profile production --platform all
eas submit --profile production --platform ios
eas submit --profile production --platform android
eas update --branch production --message "..."
```

## Sentry
```bash
pnpm sentry:release        # cuts a release, uploads sourcemaps + dSYMs
pnpm sentry:debug-id       # prints debug IDs for the current bundle
```

## Useful one-offs
```bash
xcrun simctl list devices
adb logcat -s ReactNativeJS:V                       # JS console on Android
adb shell dumpsys location                          # debug background location
xcrun simctl push booted com.trailmate.app fixture.apns   # test silent push
```
