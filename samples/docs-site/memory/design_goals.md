# Design goals — writing style guide

## Priority order (when goals conflict, top wins)
1. **Accuracy.** A wrong example is worse than no example. If unsure, mark `:::caution unverified` or omit.
2. **Brevity.** Cut every word that doesn't change meaning. Working engineers scan; they don't read.
3. **Consistency.** Same term, same casing, same code style across pages. The glossary is canonical.
4. **Completeness.** Cover the common path well; edge cases get their own how-to, not parentheticals.

## Sentence-level rules
- Active voice. "Run `dx deploy`" not "`dx deploy` should be run".
- Second person ("you"), present tense. No "we", no future tense in instructions.
- One idea per sentence. If a sentence has two commas and an "and", split it.
- No filler: avoid "simply", "just", "easily", "obviously", "of course".
- No marketing adjectives: avoid "powerful", "robust", "seamless", "modern".
- Numbers under 10 are spelled out except in code, versions, counts, and CLI flags.
- Code identifiers in backticks always: `service.yaml`, `DX_TOKEN`, `dx login`.
- Link text is the destination's title or a noun phrase, never "click here" or "this".

## Page-level rules
- First sentence states what the reader will be able to do or know after reading.
- No "Introduction" section on how-to or reference pages. Get to the steps.
- Reference pages: tables before prose. Prose explains the table, not vice versa.
- Tutorials end with "What's next" linking to 2-3 follow-ons. Never more.
- Every page has an `owner:` frontmatter field. No owner, no merge.

## What we do not do
- No screenshots of CLI output (they rot). Use fenced code blocks.
- No video. Bandwidth + accessibility + maintenance cost too high.
- No nested admonitions (`:::note` inside `:::tip`). One level only.
