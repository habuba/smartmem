# System patterns — software library

## Code style
- Public API surface is small and documented. Internals are free-form.
- Every exported symbol has a one-line doc comment.
- No global mutable state.

## Testing
- Unit tests live next to the code they test.
- Public API has integration tests that run against the built artifact.
- Mocking is allowed for I/O only — never for the unit under test.

## Release
- Semver. Breaking changes only at major.
- Every release: tag, CHANGELOG entry, smoke test against a clean install.

## Anti-patterns
- Adding deps for utilities (date, slugify, etc.) — write 5 lines instead.
- Re-exporting half a dep's API. Wrap or expose nothing.
