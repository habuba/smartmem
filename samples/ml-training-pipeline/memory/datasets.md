# Datasets

All datasets are DVC-tracked. Versions are immutable once published; bumping = new version + decision note.

## `catalog-train-v4` (current train)
- Source: weekly catalog dump joined to merch-confirmed tags, snapshot 2026-04-12.
- DVC: `data/processed/catalog-train-v4.parquet` (md5 in `dvc.lock`).
- Rows: 1,842,317 SKUs after filtering (had ≥ 1 confirmed tag, primary image exists, title non-empty).
- Columns: `sku_id, title, description, image_sha, tags (list[str])`.
- Label space: 840 tags (intersection with live taxonomy as of 2026-04-12).
- Distribution: heavy long tail. Top 50 tags cover 61% of positives; bottom 180 tags have < 50 positives each. ~12% of SKUs have only one tag; median tag-per-SKU is 4.

## `catalog-val-v4`
- Same snapshot, held-out by SKU hash (mod 100 ∈ [90, 94]).
- Rows: 92,118. Distribution mirrors train within ±0.4pp per tag.
- Use: hyperparameter selection, calibration fitting, early stopping.

## `holdout-2026-04` (frozen)
- SKU hash mod 100 ∈ [95, 99].
- Rows: 92,059. Frozen on 2026-04-15 — see decision 2026-04-15. No peeking, no tuning against it. Reported metrics in `experiments.md` and `model_registry.md` are all on this set.

## `catalog-train-v3` (deprecated)
- Pre-2026-02 snapshot. Had row duplication bug (decision 2026-02-14). Kept around only for reproducing pre-v3 experiments. Do not use for new work.

## `merch-feedback-2026-q1` (auxiliary)
- Logged accept/edit/reject events from the SKU editor, Q1 2026. 4.1M events. Used for analysis and for the upcoming weak-supervision experiment (T-021), not for current training.

## Splits — invariant
- Splits are deterministic by `int(sha256(sku_id)[:8], 16) % 100`. Never re-randomize. A SKU is in the same split forever, across dataset versions.
