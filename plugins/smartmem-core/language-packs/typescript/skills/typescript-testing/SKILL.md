---
name: typescript-testing
description: vitest/jest patterns for TypeScript. Apply when writing, modifying, or running TS tests.
---

# TypeScript testing

- **Runner**: vitest (preferred) or jest. Match files: `*.test.ts(x)` next to source.
- Use `describe` for grouping when ≥3 related tests; otherwise top-level `test`.
- Test names start with the behavior, not the function: `"returns null when input is empty"` not `"test_foo"`.
- Mock at module boundaries via `vi.mock` / `jest.mock`. Don't mock the unit under test.
- Use `vi.useFakeTimers()` for time-dependent code; restore in `afterEach`.
- For React: `@testing-library/react` + `@testing-library/user-event`. Query by accessible name first (`getByRole`).
- Snapshots: only for stable, structural data. Never for HTML/JSX (too noisy).
- Run: `vitest --watch` in dev, `vitest run` in CI.
