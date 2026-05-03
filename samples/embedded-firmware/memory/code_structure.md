# Code structure — tempnode

```
tempnode/
├── CMakeLists.txt              # top-level, picks toolchain via preset
├── CMakePresets.json           # debug / release / renode-sim / coverage
├── cmake/
│   ├── arm-none-eabi.cmake     # toolchain file (gcc 12.3 pinned)
│   └── stm32l4.cmake           # MCU-specific flags, linker script selection
├── boards/
│   └── tempnode_v1_3/
│       ├── board.h             # pin map (mirrors hw_context.md)
│       ├── board.c             # GPIO init, clock tree, BOR setup
│       └── tempnode_v1_3.ld    # linker script (128K flash, 40K RAM, EEPROM region)
├── app/
│   ├── main.c                  # HAL init → BSP init → FreeRTOS start
│   ├── tasks/
│   │   ├── radio_task.c        # LoRaMac-node glue, TX/RX state machine
│   │   ├── sensor_task.c       # SHT40 driver call + sample queue post
│   │   ├── power_mgr.c         # sleep gating, refcount, BOR ISR
│   │   └── cli_task.c          # UART shell (DEBUG-strap gated)
│   ├── proto/
│   │   └── uplink_v2.c         # binary payload encoder, schema tag 0x02
│   └── diag/
│       └── selftest.c          # boot self-test, reset-cause classifier
├── drivers/
│   ├── sht40.c                 # I2C single-shot, no clock-stretching path
│   ├── sx1262_hal.c            # Semtech HAL impl over SPI1 + DIO1 EXTI
│   └── eeprom_emul.c           # 2-bank flash wear-level
├── third_party/
│   ├── FreeRTOS-Kernel/        # v10.6.1, submodule
│   ├── LoRaMac-node/           # v4.7.0, submodule
│   └── STM32CubeL4/            # HAL/LL, submodule (only LL used in production)
├── sim/
│   ├── tempnode.repl           # Renode platform description
│   └── tests/                  # Robot framework HIL scripts
├── tests/                      # GoogleTest, host-compiled, mocks under tests/mocks
└── tools/
    ├── provision_keys.py       # generates DevEUI/AppKey CSV per production lot
    └── power_log_parse.py      # parses Otii / Joulescope CSV → avg current report
```

## Where to look for what
- A pin moved? `boards/tempnode_v1_3/board.h` is the source of truth, hw_context.md mirrors it.
- LoRaMac callbacks? `app/tasks/radio_task.c` — `OnMacMcpsConfirm`, `OnMacMlmeConfirm`.
- Sleep current regression? `app/tasks/power_mgr.c` + `drivers/*` peripheral deinit paths.
