---
name: karpathy-guidelines
description: Behavioral rules for code-writing tasks distilled from Karpathy's notes on LLM coding pitfalls. Apply when writing, reviewing, or refactoring code in any smartmem project.
---

# Coding rules

1. **Think before coding.** Read the request twice. State the smallest change that satisfies it. Do not generalize a one-shot fix into a framework.

2. **Simplicity first.** Three similar lines beats a premature abstraction. No helper unless used 3+ times.

3. **Surgical changes.** Every changed line should trace directly to the user's request. If you can't justify it in one sentence, revert it.

4. **Goal-driven execution.** Done = the user's stated outcome works end-to-end. Not "tests pass" alone, not "type-checks." Run the code.

5. **No defensive scaffolding for impossible cases.** Trust internal callers and framework guarantees. Validate only at boundaries.

6. **Comments are last resort.** Names should explain what; comments only when WHY is non-obvious.
