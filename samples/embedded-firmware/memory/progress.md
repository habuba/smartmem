# Progress — tempnode firmware

## Shipped
- **v1.2.0 — 2026-03-30** — pilot release, 200 nodes deployed in customer cold-chain trial.
  - BOR threshold raised to Level 2; brown-out crashes resolved.
  - Reservoir cap added at SX1262 PA (HW change v1.2 board).
  - FreeRTOS port stable; RX-window jitter ≤ 30 µs measured.
  - Bench avg current: 14.5 µA (above NFR-PWR-1 target of 12 µA — known gap).
- **v1.1.0 — 2026-02-20** — internal alpha, 12 boards on bench.
  - First end-to-end OTAA join + uplink to ChirpStack.
  - Bare-metal scheduler — failed jitter spec, drove ADR-002.
- **v1.0.0 — 2026-01-30** — bring-up firmware. Blink + UART hello. STM32L4 clock tree validated.

## In flight
- **v1.3.0** — production-candidate. Blocked on T-014 (flash DPD power fix) and T-016 (rejoin backoff). Target tag: 2026-05-15. Acceptance:
  - 30-min Otii avg ≤ 11.5 µA on rev v1.3 hardware.
  - 72h network-loss soak passes (no rejoin storm, clean recovery).
  - Renode CI green; nightly HIL green for 7 consecutive nights.

## Roadmap
- **v1.4.0** (~2026 Q3) — region SKUs (US915, AU915, AS923). ADR profile per region.
- **v1.5.0** (~2026 Q4) — FUOTA over LoRaWAN multicast, dual-bank flash layout, signed image verification.
- **v2.x** (~2027) — STM32WL55 die revisit (see ADR-001 gate). Single-die would save ~$1.20 BOM.

## Field telemetry (v1.2 pilot, day-60 snapshot)
- 198/200 nodes online. 2 lost — 1 confirmed mechanical (forklift), 1 unknown (suspect HW, returned for analysis).
- Median Vbat: 2.91 V (started 3.05 V) → consistent with 5y projection at current avg µA.
- Lost-uplink rate: 0.07% (within NFR target).
