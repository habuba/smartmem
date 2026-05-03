# Tasks

## Open
- [ ] T-031 (2026-05-03) Fix iOS background location 8-min cutoff (see active_context). Owner: @sam
- [ ] T-032 (2026-05-03) Samsung notification icon — ship hard-alpha `ic_notification.png`
- [ ] T-033 (2026-05-02) Chunk GPX import into 500-row batches to avoid SQLite lock
- [ ] T-034 (2026-05-02) Add Reassure perf tests for TrailListScreen with 1000-item fixture
- [ ] T-035 (2026-05-01) Wire EAS Update branch `staging` for QA
- [ ] T-036 (2026-04-30) Replace Alert with custom bottom-sheet confirm in destructive flows
- [ ] T-037 (2026-04-29) Add e2e Maestro flow: import GPX → start recording → background → resume
- [ ] T-038 (2026-04-29) Audit all `useEffect` for missing deps (eslint plugin + manual sweep)

## Done
- [x] T-030 (2026-04-28) Bump RN to 0.76, enable new arch, regression-test on iPhone 12 + Pixel 6
- [x] T-029 (2026-04-25) Migrate state from RTK to Zustand, persist via MMKV
- [x] T-028 (2026-04-22) Switch DB layer to op-sqlite, rewrite repos
- [x] T-027 (2026-04-18) Implement offline tile pack download UI + progress
- [x] T-026 (2026-04-15) Replace react-native-maps with MapLibre GL Native
- [x] T-025 (2026-04-10) Initial Sentry integration with release health
