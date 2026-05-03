# Architecture

## Pipeline (DVC stages)
```
ingest → preprocess → encode_images → train → eval → calibrate → register
```

### ingest (`dvc.yaml::ingest`)
Pulls the weekly catalog dump from S3 (`s3://catalog-dumps/`), filters to active SKUs with at least one human-confirmed tag, writes parquet to `data/raw/`. Deterministic: seeded sample if `--smoke`. Output is DVC-tracked.

### preprocess (`dvc.yaml::preprocess`)
Cleans titles (unicode NFKC, lowercased, no HTML), tokenizes with the fast DeBERTa-v3 tokenizer (`truncation_side=left`, max_len=192). Splits into train/val/test by SKU hash modulo (stable across reruns). Writes `data/processed/{train,val,test}.parquet`.

### encode_images (`dvc.yaml::encode_images`)
Runs CLIP-ViT-B/16 over the primary image of every SKU once. Caches by SHA256(image_bytes) in `data/img_cache/`. This stage is the slow one; it skips already-cached SHAs.

### train (`dvc.yaml::train`)
Ray Train job, 4x A100. Hydra config from `configs/exp/<id>.yaml`. Logs to W&B project `tagclass`. Saves checkpoints to `s3://tagclass-models/runs/<run_id>/`. Best checkpoint by val macro-F1 is symlinked as `best.pt`.

### eval (`dvc.yaml::eval`)
Loads `best.pt`, runs on `holdout-2026-04`. Emits per-tag F1, macro-F1, micro-F1, ECE, latency profile. Writes `reports/eval/<run_id>.json` (DVC metric).

### calibrate (`dvc.yaml::calibrate`)
Temperature scaling on val; per-tag threshold optimization for F1. Writes `artifacts/<run_id>/calibration.json`.

### register (`dvc.yaml::register`)
Promotes a run to a candidate slot in `model_registry.md` *only if* eval gates pass.

## Eval gates (must all pass to register)
1. macro-F1 on holdout ≥ current prod − 0.005 (no regression).
2. No tag with > 100 train positives has F1 < 0.30.
3. p99 latency on the latency-bench script ≤ 90ms.
4. ECE on validation ≤ 0.05 after calibration.
5. Drift check: no more than 3 tags renamed/removed vs the live taxonomy.

Promotion to **prod** is a manual decision recorded in `decisions.md`; the gates only get a model into the candidate pool.
