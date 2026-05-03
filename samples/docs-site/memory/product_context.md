# Product context

## Readers
1. **New-hire engineer (week 1-2).** Wants a golden path: clone template, deploy hello-world, find their team's service. Reads tutorials end-to-end.
2. **Working engineer (daily).** Searches for a specific snippet — env var name, CLI flag, error code. Lands via Algolia, scans, copies, leaves. Median session: 38 seconds.
3. **Tech lead / staff (weekly).** Reviews architecture explainers before design docs. Reads explanation pages cover-to-cover.
4. **Platform team (authors).** Edits and reviews PRs. Wants fast local preview and trustworthy CI.

## Jobs-to-be-done
- "Get my service deployed to staging today."
- "Find the exact env var / flag / endpoint."
- "Understand why the platform does X before I propose Y."
- "Copy a snippet that actually works on the version we run."

## Distribution
- Primary entry: `dx.internal/docs` (Vercel, behind SSO).
- Secondary: linked from `dx --help`, error messages in the CLI, and Slack bot answers.
- DocSearch indexes nightly; staging preview per PR via Vercel.

## Anti-personas
- External users: this site is internal-only. No marketing copy, no redaction review.
- Casual browsers: we don't optimize for serendipity. Search and direct links dominate.
