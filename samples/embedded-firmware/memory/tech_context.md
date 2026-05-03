# Tech context — tempnode

## Toolchain
- arm-none-eabi-gcc 12.3.rel1 (pinned, in `ghcr.io/tempnode/fw-builder:12.3`).
- CMake ≥ 3.25, Ninja.
- west (Zephyr-style multi-repo manifest, used here just for submodule + flash wrapper, not for Zephyr).
- OpenOCD 0.12.0 with stlink-v2-1 config.
- Renode 1.14 for HIL sim.
- GoogleTest 1.14 for host-side unit tests.

## Build
```
# configure + build production firmware
cmake --preset release
cmake --build --preset release            # → build/release/tempnode.elf + .bin + .hex

# debug build (LOG_LEVEL=3, no -Os, asserts on)
cmake --preset debug
cmake --build --preset debug

# host unit tests (no MCU, mocks under tests/mocks)
cmake --preset host-tests
cmake --build --preset host-tests
ctest --preset host-tests --output-on-failure

# coverage
cmake --preset coverage && cmake --build --preset coverage && ctest --preset coverage
gcovr -r . --html-details build/coverage/cov.html
```

## Flash / debug
```
# flash via west wrapper (calls openocd under the hood)
west flash --runner openocd --hex-file build/release/tempnode.hex

# raw openocd
openocd -f interface/stlink.cfg -f target/stm32l4x.cfg \
        -c "program build/release/tempnode.elf verify reset exit"

# gdb attach
arm-none-eabi-gdb build/debug/tempnode.elf -ex "target extended-remote localhost:3333"
```

## Renode HIL
```
# headless run, exits non-zero on test failure
renode -e "include @sim/tempnode.resc; runMacro $tests" --disable-xwt

# interactive
renode sim/tempnode.resc
(monitor) start
(monitor) sysbus.usart2 CreateLineBasedMonitor
```

## Power measurement
- Otii Arc on Vbat rail. Script in `tools/power_log_parse.py` ingests CSV and reports avg µA over a configurable window. CI gate: avg ≤ 12 µA over a 60 s deep-sleep window.

## CI
- GitHub Actions, self-hosted runner with stlink + Otii. Renode tests on every PR, real-HW tests nightly.
