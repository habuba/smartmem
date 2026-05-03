# Tasks

## Open
- [ ] T-014 (2026-04-28) Land `fix/flash-dpd` — issue MX25R DPD (0xB9) before SPI1 clock gate. Acceptance: 30-min Otii avg ≤ 11.5 µA.
- [ ] T-015 (2026-04-28) Verify SPI1 MOSI/SCK pin state during sleep with scope. If floating, force analog-input in `peripheral_release`.
- [ ] T-016 (2026-04-25) Implement exponential backoff with jitter on LoRaWAN join retry #2+. Cap at 1h.
- [ ] T-017 (2026-04-22) Fix Renode .repl SX1262 BUSY timing — current model deasserts BUSY 10x faster than real chip.
- [ ] T-018 (2026-04-20) HIL fault-injection test for `eeprom_emul.c` bank swap (yank Vbat mid-write).
- [ ] T-019 (2026-04-18) Decide on SHT40 self-heating mitigation: 100 ms gap vs. document +0.3C cold bias.
- [ ] T-020 (2026-04-10) Stub FUOTA (LoRaWAN multicast FW update) — feature-gated off in v1.3, target v1.5.

## Done
- [x] T-013 (2026-04-22) Disable LED_DIAG in production builds (-1.1 µA).
- [x] T-012 (2026-04-15) Migrate from HAL to LL drivers in production path.
- [x] T-011 (2026-04-08) Reset-cause classifier: log RCC->CSR + RTC backup tag on every boot.
- [x] T-010 (2026-04-02) Binary payload schema v2 (1B tag) implemented in `app/proto/uplink_v2.c`.
- [x] T-009 (2026-03-25) BOR threshold raised to Level 2 (2.4 V). Brown-out crashes at low-batt+cold gone.
- [x] T-008 (2026-03-18) Reservoir cap added at SX1262 PA pin (100 µF tantalum). HW change rolled into v1.3.
- [x] T-007 (2026-02-28) FreeRTOS port up; all 4 tasks running; deep-sleep entry from idle hook working.
- [x] T-006 (2026-02-14) Switched bare-metal scheduler → FreeRTOS (ADR-002).
