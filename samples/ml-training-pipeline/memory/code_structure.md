# Code structure

```
tagclass/
├── configs/
│   ├── config.yaml              # Hydra root; defaults list
│   ├── data/                    # dataset variants (v3, v4, smoke)
│   ├── model/                   # backbone configs (deberta_v3_large, roberta_large, distil)
│   ├── trainer/                 # ray, single_gpu, cpu_smoke
│   ├── loss/                    # bce, focal, asymmetric
│   ├── sampler/                 # uniform, weighted, none
│   └── exp/                     # one file per experiment (v01..v20)
├── src/tagclass/
│   ├── data/                    # datasets, collators, sharding
│   ├── models/                  # backbone wrappers, classification head, image branch
│   ├── losses/                  # BCE, focal, asymmetric loss
│   ├── train/                   # Ray Train entrypoint, lightning module
│   ├── eval/                    # metrics, calibration, latency bench
│   ├── serve/                   # FastAPI inference app, ONNX export
│   └── utils/                   # seeding, hydra resolvers, S3 helpers
├── scripts/                     # repro one-offs; nothing imported by src/
├── dvc.yaml                     # pipeline stages
├── params.yaml                  # DVC params (mirrors active Hydra config)
├── tests/                       # pytest; smoke set under tests/fixtures/
├── notebooks/                   # exploration only — never sources of truth
└── memory/                      # this directory
```

## Boundaries
- Anything under `src/tagclass/train/` may use Ray. Nothing else may import Ray.
- `src/tagclass/serve/` must run on CPU and on a single T4. No training-only deps.
- Notebooks are read-only artifacts of exploration. If logic is reused, it gets pulled into `src/`.
