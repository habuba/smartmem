# Active context

## Now
- Initial scaffold complete. All 6 plugins, wizard, hooks, agents, skills, templates, install scripts, README written. Awaiting first end-to-end smoke.

## Open threads
- Verify wizard.sh manifest parsing on a Linux system (the python-heredoc approach).
- Decide whether to ship `concise` skill as core or as a separate `smartmem-concise` plugin.

## Recently decided
- 2026-05-01: Distribute as plugin marketplace + non-marketplace install fallback (both).
- 2026-05-01: hookMode default = `full`; finalizer is the only writer; SubagentStop auditor as warning, not blocker.
- 2026-05-01: Caveman handled via wizard menu — depend on JuliusBrussee/caveman OR ship `concise` skill.
