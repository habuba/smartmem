# active_context

## Now
- Boss fight desync on host migration. Repro: 4-player, kill mini-boss, host pulls ethernet during the second boss phase. New host promotes, but boss buff stack count (the "enrage" stack from phase transition) is missing from the snapshot delta — new host shows boss at 0 stacks, old clients still rendering 3. Damage numbers diverge from there.
- Suspect: `BossBuffComponent.stackCount` not flagged dirty in snapshot writer. Look at `Game.Net.SnapshotWriter.WriteEntity` ~L240.
- Workaround for playtest: full snapshot on migration instead of delta. Costs ~8KB extra one-time. Acceptable for v1 if root fix slips.

## In flight
- Weapon mod stat caching — `WeaponRuntimeStats` cache is keyed on mod array reference, not content. Hot reload in editor invalidates incorrectly. Low priority.
- UI Toolkit lobby screen — first pass merged, designer wants animated player-ready checkmarks.

## Recently decided
- 2026-04-22: Drop Linux build target for v1. Steam Deck via Proton instead. Saves 3-4 weeks of IL2CPP-on-Linux pain.
- 2026-04-15: Boss telegraphs go to 500ms minimum (was 400). Playtest data showed 4-player chaos eats 100ms of player reaction.
- 2026-04-10: Loot claim timer = 8s. Tested 5/8/12; 8 hit the sweet spot for "nobody felt rushed, nobody felt held up."

## Blocked
- Steam partner rep hasn't returned the depot config for `internal` branch. Unblocks closed alpha distribution.
