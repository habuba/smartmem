---
name: java-style
description: Java coding rules — null handling, exceptions, package layout. Apply when writing or reviewing Java in this project.
---

# Java style

- Java 17+ baseline (records, switch expressions, pattern matching).
- Nulls: prefer `Optional<T>` for return types where absence is meaningful. Don't use `Optional` for fields or parameters.
- Exceptions: checked only for recoverable, caller-action-required failures. Otherwise unchecked. Always preserve cause via `new X("...", cause)`.
- Immutability by default — use `record` for data carriers, `final` on fields and locals.
- Streams for collection transforms; classic `for` for side effects.
- Package layout: feature-first (`com.acme.billing`), not layer-first (`com.acme.controllers`).
- Tests: JUnit 5, AssertJ for assertions. One test class per production class.
- Build: Maven or Gradle (pinned). Format with `spotless`. Lint with `errorprone` or `spotbugs`.
