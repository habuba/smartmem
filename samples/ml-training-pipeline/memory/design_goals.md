# Design goals

## Accuracy
- Macro-F1 is the headline metric. We weight all 840 tags equally because the long tail is where merch gets the most value (head tags are easy and merch doesn't need help).
- Per-tag F1 floor: no tag with > 100 train positives may have F1 < 0.30 in production. Violators block deploy; they go to label audit first.
- Calibration matters as much as accuracy. ECE (expected calibration error) target < 0.05 on validation. Merch ops UI uses the probability directly to color-code chips.

## Latency
- Hard ceiling: p99 < 90ms on T4, batch=1, input ≤ 512 tokens + 1 image.
- We're willing to spend up to 20ms on the image branch (CLIP encode is cached for repeat images via SHA key).
- Distill if the teacher exceeds budget — never serve a backbone that doesn't fit.

## Reproducibility
- Every run is fully reproducible from `(git_sha, dvc_lock_hash, hydra_config_hash, seed)`. CI verifies this on a 100-row smoke set per PR.
- No "fix the seed and retrain" reruns without a config delta. If the same config gives a different number, that's a bug, not a vibe.
- Data is DVC-tracked end to end. No cell in a notebook ever writes to a path that isn't a DVC output.

## Cost
- Train budget: ≤ $400/run on 4x A100 (≈ 6 hours). Sweeps go to spot.
- Serving budget: ≤ $0.0008 per inference at projected Q3 volume.

## Non-goals
- Beating SOTA on any public benchmark. We optimize for `holdout-2026-04` and merch accept-rate, full stop.
