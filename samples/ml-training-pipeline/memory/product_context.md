# Product context

## Workflow
1. Vendor or internal team uploads SKU draft (title, description, images).
2. Ingest service POSTs to the tagclass inference endpoint with text + first image bytes.
3. Endpoint returns top-k tags (k=10) with calibrated probabilities and a confidence band.
4. Merch ops sees pre-filled tag chips in the SKU editor. They accept, edit, or reject.
5. Final tags are written back to the catalog DB and shipped to search index.

## SLAs
- Inference availability: 99.5% monthly.
- p99 latency: < 90ms at batch=1 on T4. p50 budget is 30ms.
- Throughput: 200 RPS sustained, 600 RPS burst (Black Friday onboarding spikes).

## Failure modes the product cares about
- Confidently wrong on long-tail tags — merch trusts the chip and ships bad tags. Mitigation: temperature scaling + per-tag thresholds calibrated on validation.
- Silent taxonomy drift — merch adds tag, model doesn't know. Mitigation: weekly diff job between live taxonomy and model's tag list; alert if drift > 3 tags.
- Stale embeddings on image cache — image swapped post-ingest but cache key unchanged. Mitigation: cache key = SHA256(image bytes), not SKU id.

## Feedback loop
- Every accept/edit/reject is logged with the model version. Weekly job aggregates by tag and flags tags whose accept-rate dropped > 5pp WoW into the QA triage queue.
