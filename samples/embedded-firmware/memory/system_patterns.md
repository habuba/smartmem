# System patterns — tempnode

## Memory
- **No `malloc`/`free` after `vTaskStartScheduler()`.** All task stacks, queues, semaphores created at init. Heap_4 sized to exactly the init-time high-water mark + 64B guard. We assert on `pvPortMalloc` failure and on any post-init call (custom wrapper traps it).
- All buffers > 32B are `static` in their owning compilation unit. No buffers on task stacks larger than payload pointers.
- Stack canaries: `configCHECK_FOR_STACK_OVERFLOW=2`. Hook resets via `NVIC_SystemReset()` after writing reset-cause tag to RTC backup register.

## ISRs
- ISRs **only** set a flag, give a semaphore, or post to an ISR-safe queue. No printf, no SPI, no I2C, no float ops, no calls into LoRaMac-node.
- All ISRs use `portYIELD_FROM_ISR(xHigherPriorityTaskWoken)` if they unblock a task.
- Maximum allowed ISR body: ~30 cycles. Anything heavier is a bug — defer.

## Concurrency
- Inter-task comms = queues only. No shared globals without a mutex; the only exception is the `g_reset_cause` byte (atomic read on a Cortex-M4, written once at boot).
- No mutex held across a sleep call. Period.
- No task ever calls `vTaskDelay` longer than 100ms — if you need to wait longer, you're doing power management wrong; talk to power-mgr.

## Power
- Every peripheral has a refcount. `peripheral_acquire(SPI1)` / `_release(SPI1)`. When refcount hits 0, clocks are gated and pins set to analog-input (lowest leakage).
- Pin config on sleep entry: every unused GPIO is analog-input, no pull. Every floating digital input is the #1 source of mystery µA.
- Verify every PR's deep-sleep current on the bench rig (Otii Arc, 1µA resolution). Attach the trace to the PR.

## Watchdog
- IWDG, ~4s timeout (LSI/256, RL=0xFFF). Fed **only** in `vApplicationIdleHook`. If any task hogs CPU >4s, we want the reset.
- IWDG runs in Stop2 (LSI keeps clocking). Sized to allow ~3 RX windows of jitter.

## Logging
- Compile-time gated via `LOG_LEVEL`. Production build: `LOG_LEVEL=0` → all log macros expand to nothing. UART2 TX pin reverts to analog-input.
- No string formatting in ISR. Ever.

## Error handling
- `Error_Handler()` (HAL default) is overridden: log reset-cause tag to RTC backup reg, then `NVIC_SystemReset()`. We don't try to recover unknown HAL errors in the field.
