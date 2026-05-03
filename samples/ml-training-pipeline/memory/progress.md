# Progress

## 2026-05-01
- v20 (focal γ=1.5 + weighted sampler) launched on the Ray cluster; epoch 3/5 looking promising (val 0.720, head tags within -0.2 of v17).
- Distillation track (T-018) scoped: 6-layer DeBERTa student, KL on logits + MSE on penultimate.

## 2026-04-29
- Decision: DeBERTa-v3-large becomes the default backbone (decision 2026-04-29).
- v18 candidate registered; blocked on latency.

## 2026-04-26
- Focal loss landed (T-012). v18 trained; +1.4 long-tail F1, -0.6 head F1.

## 2026-04-22
- Tokenizer pinned with `truncation_side=left` (T-011, decision 2026-04-22). Preprocess stage hash bumped; full pipeline re-run.

## 2026-04-15
- `holdout-2026-04` frozen (T-010, decision 2026-04-15). CI guard added.

## 2026-04-12
- `catalog-train-v4` and `catalog-val-v4` published to DVC (T-009). 1.84M train rows, 92k val rows on the new snapshot.

## 2026-03-18
- CLIP image branch shipped to prod via v15+image variant. +1.0 macro-F1.

## 2026-03-02
- v15 (RoBERTa-large, BCE, no image branch) deployed to prod. Holdout 0.673. First production model.

## 2026-02-14
- SKU-hash sharding fix landed. Pre-fix numbers retired.
