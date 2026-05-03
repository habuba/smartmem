# Tasks

## Open
- [ ] T-014 (2026-04-20) Migrate eval harness to DVC-tracked `holdout-2026-04` snapshot (drop in-repo CSV)
- [ ] T-015 (2026-04-22) Investigate rank-0 OOM on Ray checkpoint save when image batch > 32
- [ ] T-016 (2026-04-26) Finish v20 sweep (focal γ=1.5 + weighted sampler), 5 epochs, decide vs v18/v19
- [ ] T-017 (2026-04-27) Re-label audit on `home_decor/*` subtree — coordinate with merch ops
- [ ] T-018 (2026-04-28) Distill DeBERTa-v3-large → 6-layer student to hit p99 < 90ms on T4
- [ ] T-019 (2026-04-29) Per-tag threshold optimization on val for v18 and v19 candidates
- [ ] T-020 (2026-04-30) Add taxonomy-drift check as an eval gate (block register if drift > 3 tags)
- [ ] T-021 (2026-05-01) Spike: weak supervision from `merch-feedback-2026-q1` accept events

## Done
- [x] T-013 (2026-04-29) Switch default backbone to DeBERTa-v3-large in `configs/model/` defaults
- [x] T-012 (2026-04-26) Add focal loss (`src/tagclass/losses/focal.py`) + Hydra `loss=focal` config
- [x] T-011 (2026-04-22) Pin tokenizer with `truncation_side=left`; bump preprocess stage hash
- [x] T-010 (2026-04-15) Freeze `holdout-2026-04`; add CI guard against accidental holdout reads in train code
- [x] T-009 (2026-04-12) Publish `catalog-train-v4` and `catalog-val-v4` via DVC
