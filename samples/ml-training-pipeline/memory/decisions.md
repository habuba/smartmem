# Decisions (ADR-lite)

## 2026-04-29 — Switch backbone from RoBERTa-large to DeBERTa-v3-large
- Context: v15 (RoBERTa-large) holdout 0.673; v16 (DeBERTa-v3-large, otherwise identical) holdout 0.704.
- Decision: Make DeBERTa-v3-large the default in `configs/model/`. RoBERTa stays in the repo for ablations.
- Trade-off: +3.1 holdout F1; same training cost; p99 latency goes 62ms → 110ms (over budget). Latency addressed via distillation track (T-018), not by sticking with RoBERTa.
- Reversible: yes (config flip).

## 2026-04-22 — Pin fast tokenizer with `truncation_side=left`
- Context: titles are more discriminative than the long tail of descriptions. Default `truncation_side=right` was lopping off titles when title+desc > 192 tokens.
- Decision: `tokenizer.truncation_side = "left"`, max_len 192. Re-ran preprocess stage; train-v4 hash bumped.
- Effect: +0.4 val F1 on a ceteris paribus rerun; no latency change.

## 2026-04-15 — Freeze `holdout-2026-04` until end of Q2
- Context: We were peeking at holdout when triaging weekly. That's Goodhart-bait.
- Decision: Holdout is read-only for humans and CI until 2026-06-30. Validation is the only set used for hyperparameter selection.
- Enforcement: CI grep blocks any import of holdout paths from `src/tagclass/train/`.

## 2026-03-18 — Add CLIP image branch (frozen) to the model
- Context: visually-distinctive tag families (`color/*`, `pattern/*`) had F1 stuck around 0.55 with text-only.
- Decision: Concatenate a 256-d projection of CLIP-ViT-B/16 image embedding to the text CLS before the classification head. Image encoder is frozen; only the projection trains.
- Effect: +1.0 macro-F1 overall; +2.4 on `color/*`. Cost: +12ms p99 latency (within budget then).

## 2026-02-14 — Re-shard by SKU hash, not row index
- Context: A vendor data dump duplicated some SKUs as separate rows. Index-based sharding put the same SKU on multiple Ray workers, leaking labels and inflating val F1 by ~1.5pp.
- Decision: Shard exclusively by SKU hash. Add `assert_unique_per_shard` test in CI. Deprecated `catalog-train-v3` was the last dataset trained under the broken sharding; all reported numbers since are post-fix.
