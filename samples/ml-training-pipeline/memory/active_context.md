# Active context

## Now
- Class imbalance on the long-tail tags (bottom ~180 tags have <50 positives in train). v18 (focal loss, gamma=2.0) beat baseline by +1.4 macro-F1 but regressed head tags by -0.6. Currently A/B-ing focal vs WeightedRandomSampler (exp v19) vs combined (v20).
- Holdout macro-F1 sitting at 0.704; gate to promote is 0.71. Two candidates close (`tagclass-deberta-v3-large-v18`, `-v20`) — see `model_registry.md`.
- Ray Train cluster occasionally OOMs on rank-0 during checkpoint save when batch images > 32. Working theory: image feature cache not being released before save. Repro is flaky.

## Open threads
- Decide: focal loss vs sampler reweight vs both. Need v19/v20 to finish full 5-epoch sweep (ETA tomorrow EOD).
- Label noise audit on the `home_decor/*` subtree — merch flagged ~200 mis-tagged SKUs. Pending re-label by ops.
- Migrate eval harness off the in-repo CSV holdout to the DVC-tracked `holdout-2026-04` snapshot. Half-done; see T-014.
- DeBERTa-v3-large pushes p99 latency to 110ms on T4 (over budget). Distillation to a 6-layer student is queued (T-018) but not started.

## Recently decided
- 2026-04-29: Move from RoBERTa-large to DeBERTa-v3-large as the default backbone (see `decisions.md`).
- 2026-04-22: Pin tokenizer to fast tokenizer with `truncation_side=left` — title is more discriminative than the tail of the description.
- 2026-04-15: Holdout is frozen at `holdout-2026-04` until end of Q2; no peeking, no tuning against it.
