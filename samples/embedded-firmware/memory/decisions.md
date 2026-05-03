# Decisions (ADR-lite) — tempnode

## ADR-001 — 2026-01-20 — MCU = STM32L412KBU6
**Context**: needed Cortex-M4 with sub-µA Stop2, ≥128KB flash for LoRaMac-node + FUOTA dual-bank, integrated LSE/RTC.
**Decision**: STM32L412KBU6 (UFQFPN32). Rejected nRF52833 (LoRa stack maturity), STM32WL55 (single-die LoRa+MCU was attractive but cost +$1.80/unit and IQ was higher in our cold tests).
**Consequences**: external SX1262 transceiver, more BOM lines, but proven LoRa RF perf and well-characterized power profile. STM32WL revisit gate: if WL IQ improves to <2 µA in a future die rev, reconsider for v2.

## ADR-002 — 2026-02-14 — RTOS = FreeRTOS (replaced bare-metal scheduler)
**Context**: original bare-metal cooperative scheduler missed RX1 windows under SF12 + sensor-read overlap. Jitter measured up to 2.4 ms; spec is ±50 µs.
**Decision**: switch to FreeRTOS 10.6.1, tickless idle, 1 kHz tick. Radio task at top priority preempts sensor task during the 1s/2s RX window.
**Consequences**: +5.8 KB flash, +1.4 KB RAM. Determinism win: post-port jitter ≤ 30 µs measured. No power penalty (tickless idle).

## ADR-003 — 2026-02-25 — LoRaWAN stack = Semtech LoRaMac-node, no abstraction
**Context**: tempted to wrap LoRaMac-node in our own API to ease testability.
**Decision**: use Semtech LoRaMac-node v4.7.0 directly. Mock at the radio HAL boundary (sx1262_hal.c) for unit tests instead.
**Consequences**: ~3 KB flash saved, callback signatures leak into our code (acceptable). Test mocks live in `tests/mocks/sx1262_hal_mock.cc`.

## ADR-004 — 2026-03-05 — Sensor = SHT40 (replaced SHT30 from prototype)
**Context**: SHT30 single-shot read draws 1.5 mA for 12 ms. SHT40 same accuracy, 0.4 mA for 8 ms. Across 35,040 reads/yr the delta is ~1 µA average.
**Decision**: SHT40, single-shot mode, no heater.
**Consequences**: BOM +$0.40/unit. Saves 1 µA average → ~9% of total budget. Driver simplified (no clock-stretching).

## ADR-005 — 2026-04-02 — Uplink payload = binary v2 (rejected JSON proposal)
**Context**: Cloud team proposed JSON payloads for "ease of integration."
**Decision**: keep binary fixed-layout, 1-byte schema tag. Payload size: 14 B for batch-of-4 vs ~140 B for equivalent JSON.
**Consequences**: 10x airtime → 10x RF energy on every TX. JSON cost over 5 years > 200 mAh — i.e., 20% of usable battery. Non-starter. Cloud team writes a 30-line decoder.
