---
name: rust-style
description: Rust coding rules — error handling, ownership idioms, lints. Apply when writing or reviewing Rust in this project.
---

# Rust style

- Errors: `Result<T, E>` with `thiserror` for libraries, `anyhow` for binaries. Use `?` for propagation.
- No `unwrap()` / `expect()` in production paths except where invariants are documented in a comment.
- Prefer borrowing over cloning. Reach for `Cow<'_, str>` before `String::clone`.
- Don't fight the borrow checker with `Rc<RefCell<…>>` — usually means the design needs rethinking.
- `clippy` clean (no `-A` flags except in justified, scoped `#[allow]`).
- Format with `cargo fmt`. CI rejects unformatted code.
- Async: `tokio` (or `async-std`). Don't mix runtimes.
- Tests: unit tests in `mod tests` at the bottom of the file; integration tests in `tests/`.
- Use `#[non_exhaustive]` for public enums and structs that may grow.
