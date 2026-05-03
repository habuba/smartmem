# System requirements — tempnode

## Functional
- FR-1: Sample SHT40 (T, RH) every 15 min ±1s, 14-bit resolution.
- FR-2: Batch 4 samples, transmit on LoRaWAN every 60 min ±5s (EU868 SF7-SF12, ADR).
- FR-3: Confirmed uplink once per 24h with diagnostic payload (Vbat, MCU temp, reset cause, uptime, FW version).
- FR-4: OTAA join on first boot; rejoin on 8 consecutive missed confirmed uplinks.
- FR-5: UART CLI (115200 8N1) when DEBUG header shorted at boot — `stat`, `tx`, `sleep`, `flash`, `reset` cmds.

## Non-functional — Power
- **NFR-PWR-1**: average MCU current in deep sleep (Stop2 mode) ≤ 12 µA, measured at Vbat = 3.0 V, 25 C, board rev v1.3.
- NFR-PWR-2: peak TX current ≤ 130 mA at +14 dBm (SX1262, EU868). Reservoir cap sized for 200 ms TX burst.
- NFR-PWR-3: average system current over 1h cycle (4 samples + 1 TX SF12) ≤ 18 µA.
- **NFR-LIFE-1**: ≥ 5 years on CR123A (1500 mAh nominal, derate 30% for cold + self-discharge → 1000 mAh budget). 1000 mAh / 18 µA ≈ 6.3 y headroom.

## Non-functional — RF
- **NFR-RF-1**: receiver sensitivity ≤ -135 dBm at SF12/125kHz (LoRa, datasheet target).
- NFR-RF-2: TX EVM and spurious emissions compliant with EN 300 220 / FCC Part 15.247.
- NFR-RF-3: RX window timing accuracy ±50 µs of LoRaWAN spec (1.0.4).

## Non-functional — Reliability
- NFR-REL-1: IWDG reset on any task starve >4 s. Watchdog fed only in FreeRTOS idle hook.
- NFR-REL-2: BOR threshold = 2.4 V (Level 2). Below that, MCU resets cleanly before LoRa TX collapses Vcc.
- NFR-REL-3: EEPROM emulation in flash, dual-bank wear-level, ≥10k erase cycles guaranteed.

## Environmental
- NFR-ENV-1: operating range -25 C to +60 C. CR123A discharge curve characterized at -20 C, 0 C, 25 C, 45 C.
- NFR-ENV-2: IP67 enclosure (HW responsibility, but FW must tolerate condensation events without false-resetting).
