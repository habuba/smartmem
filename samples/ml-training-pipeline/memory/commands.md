# Commands

Frequently used commands, kept here so new contributors don't have to re-derive them.

## Train
```
python -m tagclass.train +exp=v20
python -m tagclass.train +exp=v20 trainer=single_gpu     # local debug
python -m tagclass.train +exp=smoke trainer=cpu_smoke    # 90s sanity
```

## Eval
```
python -m tagclass.eval run_id=v20-20260501-0930
python -m tagclass.eval.report v20-20260501-0930         # pretty-print json
python -m tagclass.eval.latency_bench --ckpt s3://tagclass-models/runs/v20/best.pt --batch 1 --n 5000
```

## DVC
```
dvc pull                  # fetch data + artifacts
dvc repro                 # full pipeline
dvc repro train           # one stage
dvc metrics show          # latest reports
dvc metrics diff HEAD~1   # compare to previous commit
dvc push                  # after a successful run
```

## W&B
```
wandb sync wandb/offline-run-*           # sync offline runs
wandb sweep configs/sweep/seed_var.yaml  # launch a sweep
```

## Hydra introspection
```
python -m tagclass.train +exp=v20 --cfg job        # print resolved config, don't run
python -m tagclass.train +exp=v20 --info defaults  # show defaults list
```

## Lint / typecheck / test
```
ruff check src/ tests/
black --check src/ tests/
mypy --strict src/
pytest -x                                          # fail on first
pytest tests/ -k "not slow"                        # skip slow tests
```

## Serving
```
python -m tagclass.serve.export_onnx run_id=v20-20260501-0930
python -m tagclass.serve.app --ckpt artifacts/v20/model.onnx --port 8080
```
