# Active context

## Now
- **Sleep current regression**: bench measures 18 µA average in Stop2; target is 11 µA. NFR-PWR-1 (≤12 µA) is breached. Blocking v1.3.0 release.
- Working theory: MX25R8035F SPI NOR flash on PB12 is not entering deep-power-down (DPD, opcode 0xB9). When we deinit SPI1 we leave NSS high but never issue DPD before clock-gating. Datasheet standby IQ is 8 µA — consistent with the delta we're seeing (18 - 11 = 7 µA).
- Reproducer: `cmake --preset release && west flash`, leave board on Otii for 5 min, observe avg current. With DPD patch (branch `fix/flash-dpd`) prelim shows 11.2 µA — within budget but want a 30-min run before merging.
- Secondary investigation: `power_mgr.c` peripheral_release(SPI1) does clock-gate but doesn't reset MOSI/SCK to analog-input — verify with scope whether they're floating during sleep.

## Open threads
- LoRaWAN rejoin storm seen in pilot when 50+ nodes brown-out simultaneously (warehouse power blip). Need exponential backoff with random jitter on join attempt #2+. Currently linear 30s retry.
- Renode model doesn't simulate SX1262 BUSY pin timing accurately — radio task passes in sim, sometimes fails on real HW with SF12. Either fix the .repl or downgrade Renode test confidence and rely more on nightly HIL.
- Coverage gap: `eeprom_emul.c` bank-swap path is only tested via host mock. Need a fault-injection HIL test that yanks Vbat mid-write.
- SHT40 self-heating: at -20C with 4-sample batch read back-to-back, we measured +0.3C bias. Add 100 ms idle between samples or accept the bias and document.

## Recently decided
- 2026-04-22: Disable LED_DIAG (PC13) entirely in production builds — saved 1.1 µA average (LED driver leakage even when off).
- 2026-04-15: Move to LL drivers exclusively in production. HAL retained only for `host-tests` mock layer. Saved ~6 KB flash, ~0.4 µA (HAL_RCC tick was waking us periodically).
- 2026-04-02: ADR-005 — switch payload schema to fixed binary v2 (1B tag). JSON proposal rejected on flash + airtime grounds.
