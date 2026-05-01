## TypeScript toolchain
- Version: TS 5.x; Node LTS
- Package manager: pnpm (preferred) / npm / bun
- Lint: `eslint` (typescript-eslint recommended-type-checked)
- Format: `prettier`
- Type-check: `tsc --noEmit`
- Test: `vitest` (preferred) or `jest`
- LSP: `typescript-language-server` (or built-in via VSCode/Cursor)

## Commands
- Install: `pnpm install`
- Build: `pnpm build`
- Type-check: `pnpm tsc --noEmit`
- Lint: `pnpm eslint .`
- Format: `pnpm prettier -w .`
- Test: `pnpm vitest run`
