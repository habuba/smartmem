# tempnode

STM32L4-based wireless temperature sensor node. LoRaWAN Class A uplink, CR123A primary cell, 5-year target life. Outdoor enclosure, -20C to +60C operating range. Board rev v1.3.

## Memory pointers
@memory/MEMORY.md
@memory/active_context.md
@memory/hw_context.md

## Working rules
- Real-time constraints are non-negotiable. LoRa TX windows are tight (RX1 = 1s after TX, RX2 = 2s). Anything that blocks the radio task more than 50ms is a bug.
- No `malloc` after `vTaskStartScheduler()`. All allocations at init or static. Heap_4 is configured for FreeRTOS object creation only — verify with `configTOTAL_HEAP_SIZE` watermark in `power-mgr` task.
- ISRs set flags / give semaphores only. No printf, no logging, no SPI/I2C in ISR context. Defer to the appropriate RTOS task via queue.
- Watchdog (IWDG, ~4s) is fed in the FreeRTOS idle hook only. If idle isn't running, we want to reset.
- Power budget is sacred: every PR that touches sleep entry/exit or peripheral init must report measured deep-sleep current delta on the bench rig. Target floor: 11µA average.
- Before non-trivial changes, read the relevant memory file:
  - pin assignments / peripherals → `memory/hw_context.md` (DO NOT guess pins from schematic memory; v1.2 → v1.3 moved several)
  - task structure / queues → `memory/architecture.md`
  - build / flash / sim → `memory/tech_context.md`
  - past hardware-affecting choices → `memory/decisions.md`
- Renode model lives in `sim/tempnode.repl` and is the primary HIL test target in CI. Hardware-in-loop on real boards runs nightly only.
- Memory is managed by `memory-finalizer`. Other agents emit `MEMORY_NOTES:`; only the finalizer writes to `memory/*.md`.
- Workflow: `/prd <slug>` → `/tasks <slug>` → `/process`.
- Keep this file <60 lines.
