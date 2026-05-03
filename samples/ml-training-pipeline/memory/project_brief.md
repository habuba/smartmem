# Project brief

## What
tagclass is a multi-label text + vision classifier that predicts product tags for SKUs at ingest time. Input: title, short description, primary image (passed through a frozen CLIP-ViT-B/16 encoder, projected, concatenated with text CLS). Output: probability over 840 tags from the merch taxonomy.

## Why
Manual tagging is the bottleneck in catalog onboarding. Median time-to-publish for a new SKU is 3.4 days, of which ~2.1 is waiting on a human tagger. Auto-suggesting top-k tags with calibrated confidence cuts the human step to a confirm-or-edit pass.

## Users
- Merch ops (primary) — see suggested tags in the SKU editor, accept/reject.
- Search relevance team (secondary) — consume tag probabilities as features.
- Catalog QA — uses low-confidence predictions as a triage queue.

## Success metrics
- Macro-F1 ≥ 0.71 on the frozen `holdout-2026-04` set.
- p99 latency < 90ms on a single T4 at batch=1.
- ≥ 60% of suggestions accepted without edit by merch ops (measured weekly).
- Time-to-publish median < 1.0 day by end of Q3.

## Out of scope
- Image-only classification (we always have title text).
- Multilingual — English catalog only for now; localized tagging is a separate workstream.
- Re-deriving the merch taxonomy. We consume it; we don't own it.
