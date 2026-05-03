# Experiments

Recent runs only. All val F1 are macro on `catalog-val-v4`; holdout F1 is on `holdout-2026-04`. All seeds = 1337 unless noted.

## v15 — RoBERTa-large baseline (refresh on v4 data)
- Hypothesis: re-baseline on the new data version before changing the backbone.
- Config: `model=roberta_large`, `loss=bce`, `sampler=none`, lr=2e-5, bs=64, 4 epochs.
- Result: val 0.681, holdout 0.673. Per-tag floor violations: 14.
- Conclusion: matches expectations from v3 data. Acceptable baseline; long-tail still bad.

## v16 — DeBERTa-v3-large swap
- Hypothesis: DeBERTa-v3-large should beat RoBERTa-large at same compute on this label space.
- Config: `model=deberta_v3_large`, lr=1.5e-5, bs=48 (smaller for memory), 4 epochs, otherwise = v15.
- Result: val 0.712, holdout 0.704. Floor violations: 9. Latency p99: 110ms (over budget — flagged).
- Conclusion: clear win on accuracy. Latency is a separate problem; queued distillation. Backbone change accepted (decision 2026-04-29).

## v17 — DeBERTa-v3-large + image branch on
- Hypothesis: CLIP image features close gaps on visually-distinctive tags (`color/*`, `pattern/*`).
- Config: v16 + `model.image_branch=clip_vitb16_frozen`, projection dim 256, concat to text CLS.
- Result: val 0.718, holdout 0.709. `color/*` tags +2.4 F1, `pattern/*` +1.8 F1. Floor violations: 8.
- Conclusion: image branch pays for itself on the targeted subtree. Keep on by default.

## v18 — Focal loss for long tail
- Hypothesis: focal loss (γ=2.0) lifts long-tail tags vs BCE.
- Config: v17 + `loss=focal loss.gamma=2.0`.
- Result: val 0.722, holdout 0.715. Long-tail (bottom 180) +1.4 F1, head (top 50) -0.6 F1. Floor violations: 5.
- Conclusion: net positive but head regression is real. A/B against sampler reweight (v19) and combined (v20).

## v19 — WeightedRandomSampler instead of focal
- Hypothesis: addressing imbalance via sampling avoids the head regression seen in v18.
- Config: v17 + `sampler=weighted` (weights ∝ 1/sqrt(tag_freq), per-SKU max-tag rule).
- Result: val 0.717, holdout 0.710. Long-tail +0.9, head -0.1. Floor violations: 7.
- Conclusion: smaller long-tail lift than v18 but no head damage. Open question.

## v20 — Focal + weighted sampler (combined) — IN PROGRESS
- Hypothesis: combining might keep v18's tail gains and v19's head stability.
- Config: v17 + `loss=focal loss.gamma=1.5` + `sampler=weighted`.
- Status: epoch 3/5 at time of writing. Val 0.720 so far; head tags within -0.2 of v17. Looks promising.
