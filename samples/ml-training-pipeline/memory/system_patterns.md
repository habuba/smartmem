# System patterns

## Deterministic seeding
- One entry point: `tagclass.utils.seeding.set_global_seed(seed)`. Sets `random`, `numpy`, `torch` (CPU + CUDA), `torch.backends.cudnn.deterministic=True`, `cudnn.benchmark=False`, and the HF tokenizer parallelism env var.
- Every Ray worker re-seeds with `seed + worker_rank` in its `train_loop_per_worker` prelude. Never share a seed across workers — that gives identical batches and silently breaks DDP.
- DataLoaders use a `torch.Generator` constructed from the same base seed; shuffle is reproducible across reruns.
- Default seed is 1337. To study seed variance, sweep `seed=[1337, 2026, 4242, 8675309, 9001]` — anything else is just noise.

## Config-as-code via Hydra
- Every run is fully described by a single composed Hydra config. No CLI overrides at runtime go un-logged: we hash the resolved config and stash it in W&B + the run dir.
- New experiment = new file in `configs/exp/<id>.yaml`, never an inline override. The exp file's defaults list pins data, model, trainer, loss, sampler.
- `params.yaml` (DVC) is generated from the active exp config so DVC sees param changes and re-triggers stages correctly. Never edit `params.yaml` by hand.

## DataLoader sharding rule
- Sharding is by SKU hash, not by row index. This guarantees a SKU never appears in two shards even if rows are duplicated upstream (which has happened — see decision 2026-02-14).
- Train shards are unbalanced by tag — that's fine; the sampler handles imbalance. Never try to "balance shards" by tag; you'll leak labels across workers.
- Validation and holdout are NOT sharded across workers during eval. Eval runs on rank-0 only. Sharded eval has bitten us twice with off-by-one on partial batches.
