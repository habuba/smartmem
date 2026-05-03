# Design goals — tempnode

## Primary (ranked, non-negotiable)
1. **Power**: sustain 5y on CR123A under EU868 duty cycle. Everything else is subordinate.
2. **Reliability**: never brick in the field. Reset paths must converge to a known-good state (LoRaWAN rejoin, last-known-good config in EEPROM emulation).
3. **Determinism**: LoRa RX windows must open within ±50µs of spec. This is what drives the FreeRTOS-over-bare-metal decision (see decisions ADR-002).

## Secondary
4. Code size <128 KB (we're on STM32L412 — 128KB flash). Leaves headroom for FUOTA dual-bank in v1.5.
5. RAM watermark <24 KB of 40 KB. Stack canaries on every task.
6. Build reproducibility — same git SHA, same binary (CMake + pinned arm-none-eabi-gcc 12.3 in container).

## Anti-goals
- No dynamic logging verbosity. Logs are compile-time gated. Production builds = silent UART, period.
- No JSON / no text protocols on air. Binary, fixed-layout, versioned by 1-byte schema tag.
- No abstraction layer over the LoRaWAN stack. We use Semtech LoRaMac-node directly. Wrappers cost flash and obscure timing.

## Trade-offs we've accepted
- We chose FreeRTOS despite ~6 KB flash cost — the determinism win is worth it (ADR-002).
- We chose SHT40 over SHT30 despite higher unit cost — single-shot mode current is half (ADR-004).
