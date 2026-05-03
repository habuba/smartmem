# System patterns

## Offline-first rule
A screen is broken if it shows a spinner or error when the device is offline but the necessary data is in SQLite. Reviewers reject PRs that fetch in `useEffect` without first reading the local repo. Pattern:

```ts
const trail = useTrail(id);          // reads from store, store hydrated from repo
const { data: live } = useQuery({    // optional enrichment
  queryKey: ['trail', id],
  queryFn: () => api.getTrail(id),
  enabled: trail != null,            // don't block first render
});
```

## Optimistic mutations
All user-initiated writes apply locally first, then sync. Helper: `useOptimisticMutation` wraps TanStack Query's mutate with a repo write before the network call. On failure: revert the repo row to its pre-write snapshot, fire a toast, log to Sentry with `level: 'warning'`.

## Errors → toast, not alert
- Network failures during background sync: silent, retried.
- Network failures during user-initiated action: toast "Couldn't reach server. We'll try again." Action stays optimistic locally.
- Validation errors (form): inline below the field. Never a toast.
- Destructive confirms ("delete this route?"): native Alert. This is the only case Alert is allowed.
- Unrecoverable errors (DB corruption): full-screen ErrorBoundary with a "reset app data" escape hatch.

## No blocking IO on render
- Never `await` in a component body. Use `useQuery`, `useStore`, or `useEffect`.
- Never read SQLite synchronously in a render path. Repos are async; stores hydrate them on app start.
- Heavy computations (GPX parsing, track simplification) run in `runOnJS` from a worklet or in a separate thread via `react-native-worklets-core`.

## Single source of truth for location
Only `services/locationTask.ts` subscribes to GPS. It pushes points into `recordingStore`. No component subscribes to `Location.watchPositionAsync` directly. This is a recurring source of bugs when violated — duplicate listeners drain battery and produce inconsistent track data.

## Naming
- Repo methods: `findById`, `findAll`, `insert`, `update`, `softDelete`. Not `get*` or `save`.
- Store actions: verbs in present tense (`startRecording`, not `setRecordingStarted`).
- Async functions never named `handle*`. Handlers are sync wrappers that call async functions.
