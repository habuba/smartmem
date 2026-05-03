# Model registry

All metrics on `holdout-2026-04`. Latency = p99 on T4, batch=1, fp16, after ONNX export.

## prod — `tagclass-roberta-large-v15`
- Backbone: RoBERTa-large (355M). Image branch: off.
- Loss: BCE. Sampler: uniform.
- Holdout macro-F1: 0.673. Micro-F1: 0.788. ECE: 0.041 (post-calibration).
- Per-tag floor violations: 14 (accepted at deploy; flagged for next refresh).
- p99 latency: 62ms. p50: 24ms.
- Deployed: 2026-03-02. Serving: ONNX on Triton, 8x T4 behind autoscaler.
- Calibration: temperature 1.18; per-tag thresholds in `s3://tagclass-models/v15/calibration.json`.

## candidate — `tagclass-deberta-v3-large-v18`
- Backbone: DeBERTa-v3-large (435M). Image branch: CLIP-ViT-B/16 frozen, 256-d projection.
- Loss: Focal (γ=2.0). Sampler: uniform.
- Holdout macro-F1: 0.715. Micro-F1: 0.812. ECE: 0.038.
- Floor violations: 5.
- p99 latency: 110ms (OVER BUDGET). p50: 41ms.
- Status: blocked on latency. Distillation candidate (T-018) targets a 6-layer student to bring p99 under 90ms.
- Trained: 2026-04-26. Run id: `v18-20260426-0915`.

## candidate — `tagclass-deberta-v3-large-v19`
- Backbone: DeBERTa-v3-large (435M). Image branch: on.
- Loss: BCE. Sampler: WeightedRandomSampler (1/sqrt freq).
- Holdout macro-F1: 0.710. Micro-F1: 0.809. ECE: 0.044.
- Floor violations: 7.
- p99 latency: 110ms (same backbone — same problem).
- Status: same blocker as v18. Useful as the no-head-regression alternative; final pick depends on v20 result.
- Trained: 2026-04-28. Run id: `v19-20260428-1733`.

## Promotion process
A candidate becomes prod only after: (1) eval gates pass, (2) shadow traffic for 7 days at full RPS, (3) merch ops accept-rate within ±2pp of current prod on the same week's SKUs, (4) decision note in `decisions.md`.
