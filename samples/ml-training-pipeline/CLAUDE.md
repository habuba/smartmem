# tagclass

Multi-label content classifier for product tagging. Predicts ~840 tags across the catalog from title + short description + first product image caption. Used by the merch team to auto-suggest tags at SKU ingest time; humans confirm.

## Stack
- Python 3.12, PyTorch 2.5, HuggingFace transformers 4.46
- Hydra for configs, DVC for data + pipeline, Weights & Biases for tracking
- Ray Train for multi-GPU; single A100 box for dev, 4x A100 for prod runs
- Target: macro-F1 ≥ 0.71 on holdout, p99 latency < 90ms on T4

## Memory pointers
@memory/MEMORY.md
@memory/active_context.md

## Rules
- Memory is written only by the `memory-finalizer` agent. Other agents emit `MEMORY_NOTES:` blocks.
- Never commit raw data, model weights, or W&B keys. DVC tracks data; weights live in S3 (`s3://tagclass-models/`).
- Every training run must have a Hydra config under `configs/exp/` and a corresponding entry in `memory/experiments.md` once finalized.
- Dataset versions are pinned via DVC. Bumping a dataset = new entry in `memory/datasets.md` + decision note.
- Don't change the loss function, sampler, or backbone without an ADR in `memory/decisions.md`.
- Determinism: seed = 1337 unless an experiment explicitly studies seed variance.
- Eval gates (see `architecture.md`) must pass before a candidate is promoted in `model_registry.md`.
- Before non-trivial changes, read the relevant pointer:
  - new experiment → `memory/experiments.md` + `memory/system_patterns.md`
  - data changes → `memory/datasets.md` + `tech_context.md` (DVC repro)
  - serving / latency → `memory/model_registry.md`
- Workflow: `/prd <slug>` → `/tasks <slug>` → `/process`.
