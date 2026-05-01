---
name: typescript-style
description: TypeScript coding rules — strictness, imports, error handling. Apply when writing or reviewing TS/TSX in this project.
---

# TypeScript style

- `tsconfig.json`: `strict: true`, `noUncheckedIndexedAccess: true`, `exactOptionalPropertyTypes: true`. Don't relax.
- **No `any`**. Use `unknown` and narrow. `// @ts-expect-error` only with a comment explaining why and a tracking issue.
- Prefer `type` aliases for unions/intersections; `interface` only when extending or for declaration merging.
- **Imports**: `import type { X }` for type-only imports. No default exports for utilities; named only.
- **Errors**: throw `Error` subclasses with meaningful names. Don't throw strings or plain objects.
- **Async**: `async/await`; never mix `.then()` chains with `await`. Always handle rejection.
- **Nulls**: prefer `undefined` for "no value." Use `??` and `?.` over manual checks.
- **Enums**: avoid `enum`; use `as const` object + union type instead.
- Format with `prettier`, lint with `eslint` (typescript-eslint recommended-type-checked).
