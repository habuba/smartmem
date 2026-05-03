# Tech context

## Environment
- Python 3.12, managed via `uv`. Lockfile: `uv.lock` (committed).
- CUDA 12.4, PyTorch 2.5.1 + cu124 wheels.
- Single A100-80GB for dev (`gpu-dev-01`); 4x A100-80GB for prod runs (Ray cluster `tagclass-train`).
- W&B project: `tagclass`. Entity: `merch-ml`. Set `WANDB_API_KEY` in env, never in repo.

## Common commands

### Train an experiment
```
python -m tagclass.train +exp=v18
```
This composes `configs/config.yaml` + `configs/exp/v18.yaml`, syncs `params.yaml`, launches Ray Train, logs to W&B run `v18-<timestamp>`.

### Smoke test (CPU, 100 rows, 1 epoch — for CI / sanity)
```
python -m tagclass.train +exp=smoke trainer=cpu_smoke
```
Must finish in < 90 seconds and produce a valid checkpoint. CI runs this on every PR.

### Eval a run against holdout
```
python -m tagclass.eval run_id=v18-20260429-1422
```
Writes `reports/eval/<run_id>.json`. Pretty-print with `python -m tagclass.eval.report <run_id>`.

### Reproduce a pipeline stage
```
dvc repro train             # only the train stage
dvc repro                   # whole pipeline
dvc repro --force eval      # re-run eval even if inputs unchanged
```

### Pull / push data and artifacts
```
dvc pull                    # data + img_cache + reports
dvc push                    # after a successful run
```

### Sync W&B run locally (if trained on a box without internet)
```
wandb sync wandb/offline-run-<timestamp>-<id>
```

### Latency bench
```
python -m tagclass.eval.latency_bench --ckpt s3://tagclass-models/runs/v18/best.pt --device cuda:0 --batch 1 --n 5000
```

### Export ONNX for serving
```
python -m tagclass.serve.export_onnx run_id=v18-20260429-1422
```

## Pre-commit hooks
`ruff`, `black`, `mypy --strict` on `src/`, `dvc-data check-ref` to block accidental data commits, `detect-secrets` for W&B / AWS keys.
