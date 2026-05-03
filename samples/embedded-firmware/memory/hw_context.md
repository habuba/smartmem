# HW context — tempnode board rev v1.3

Source of truth: `boards/tempnode_v1_3/board.h`. This file mirrors it for context — if they disagree, the header wins, then fix this file.

## MCU
STM32L412KBU6 (UFQFPN32, 128 KB flash, 40 KB SRAM). HSI16 + MSI 4MHz for run; LSE 32.768 kHz crystal for RTC; LSI for IWDG.

## Power
- Vbat = CR123A primary cell (3.0 V nominal, 2.0 V cutoff).
- TPS62748 buck-boost → 3.0 V rail, IQ ~ 360 nA. Bypass mode below Vin = 3.1 V.
- 100 µF tantalum reservoir at SX1262 PA pin (sized for 200 ms TX burst at 130 mA).

## Pin map (v1.3)
| Pin   | Net          | Function          | Notes                                         |
|-------|--------------|-------------------|-----------------------------------------------|
| PA0   | LORA_BUSY    | GPIO IN           | SX1262 BUSY, polled before SPI cmd            |
| PA1   | LORA_DIO1    | EXTI1             | RX done / TX done IRQ                         |
| PA4   | LORA_NSS     | GPIO OUT          | active low, manual control (no SPI NSS HW)    |
| PA5   | SPI1_SCK     | AF5 SPI1          |                                               |
| PA6   | SPI1_MISO    | AF5 SPI1          |                                               |
| PA7   | SPI1_MOSI    | AF5 SPI1          |                                               |
| PA9   | USART2_TX    | AF7, debug only   | analog-input in production sleep              |
| PA10  | USART2_RX    | AF7, debug only   | pull-up in DEBUG mode, analog-input otherwise |
| PA11  | LORA_RESET   | GPIO OUT, OD      | active low, 10 ms pulse on init               |
| PA12  | DEBUG_STRAP  | GPIO IN, pull-up  | shorted at boot → enable CLI                  |
| PB6   | I2C1_SCL     | AF4 I2C1          | SHT40, 400 kHz                                |
| PB7   | I2C1_SDA     | AF4 I2C1          | SHT40                                         |
| PB8   | SENSOR_PWR   | GPIO OUT          | high-side switch, gates SHT40 Vdd             |
| PB12  | FLASH_NSS    | GPIO OUT          | MX25R8035F SPI NOR (FUOTA staging, v1.5)      |
| PC13  | LED_DIAG     | GPIO OUT          | factory-test only, NC in production firmware  |
| PC14  | LSE_IN       | OSC32 IN          | 32.768 kHz                                    |
| PC15  | LSE_OUT      | OSC32 OUT         |                                               |
| PH3   | BOOT0        | strap             | tied low, factory programs via SWD            |

## Peripheral usage
- **SPI1**: SX1262 LoRa transceiver. 8 MHz, mode 0, manual NSS via PA4. DMA1 ch2/3 used for >32B payloads.
- **I2C1**: SHT40 sensor only. 400 kHz fast mode. No clock stretching path (SHT40 single-shot polls ready via NACK).
- **USART2**: debug CLI, 115200 8N1. Disabled in production at runtime; pins to analog-input.
- **RTC**: LSE-driven, Alarm A = 15 min sample tick, Alarm B reserved for LoRaWAN class C beacon (future).
- **IWDG**: LSI, prescaler /256, reload 0xFFF → ~4.1 s timeout. Fed in idle hook.

## Known v1.2 → v1.3 changes
- LORA_NSS moved PA15 → PA4 (PA15 had pull-up that leaked 8 µA).
- Added PB8 high-side switch on SHT40 Vdd (was constant-on, leaked 2.5 µA).
- Conformal coat applied post-assembly (mitigates v0 condensation shorts).
