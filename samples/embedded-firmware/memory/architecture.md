# Architecture — tempnode

## Runtime model
FreeRTOS 10.6.1, tickless idle, 1 kHz tick when active. 4 application tasks + idle. No timer service task (we use `xTimer` only for one watchdog-pet trace; the rest is event-driven via queues).

## Tasks (priority high → low)
| Task        | Prio | Stack (W) | Trigger                            | Responsibility                              |
|-------------|------|-----------|------------------------------------|---------------------------------------------|
| radio       | 4    | 512       | Q_radio msg + LoRa IRQ semaphore   | LoRaMac-node state machine, RX window timing|
| sensor      | 3    | 256       | RTC alarm A (15 min)               | I2C SHT40 read, push to Q_sample            |
| power-mgr   | 2    | 256       | Q_power msg, periodic 1Hz when up  | Sleep gate, peripheral on/off, BOR monitor  |
| cli         | 1    | 384       | UART RX line idle IRQ → semaphore  | Debug shell (only when DEBUG strap shorted) |
| IDLE hook   | 0    | (sys)     | always                             | IWDG_KR refresh, sleep entry decision       |

## Queues
- `Q_sample` (depth 8, sizeof(sample_t)=8B): sensor → radio batcher.
- `Q_radio`  (depth 4, sizeof(radio_evt_t)=12B): power-mgr → radio (TX request, join trigger).
- `Q_power`  (depth 4, sizeof(power_evt_t)=4B): any → power-mgr (request peripheral on/off).

## Interrupt model
- **EXTI 5 (SX1262 DIO1)** → ISR gives `sem_radio_irq`. Radio task processes.
- **RTC Alarm A** → ISR posts to `Q_sample` from ISR-safe variant. Wakes from Stop2.
- **USART2 RX idle** → ISR gives `sem_cli_rx`. CLI task decodes line.
- All other peripheral IRQs disabled in production build (LPUART, COMP, etc.).

## Sleep gating
power-mgr is the sole authority. It tracks `peripheral_refcount[]` for SPI1, I2C1, USART2. When all refcounts == 0 AND no task has pending work AND next RTC alarm > 50 ms away, it commands Stop2 entry. Wake source: RTC + EXTI5.

## State persistence
LoRaWAN session keys + frame counters → emulated EEPROM (last 4KB of flash, 2-bank wear-level). Written only on join-accept and every 1024 uplinks (FCnt rollover guard).
