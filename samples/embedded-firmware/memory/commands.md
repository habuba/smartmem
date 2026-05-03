# Commands — tempnode

## Build
```
cmake --preset release && cmake --build --preset release
cmake --preset debug   && cmake --build --preset debug
cmake --preset host-tests && cmake --build --preset host-tests && ctest --preset host-tests
```

## Flash / debug
```
west flash --runner openocd --hex-file build/release/tempnode.hex
openocd -f interface/stlink.cfg -f target/stm32l4x.cfg \
        -c "program build/release/tempnode.elf verify reset exit"
arm-none-eabi-gdb build/debug/tempnode.elf -ex "target extended-remote localhost:3333"
```

## Renode HIL
```
renode -e "include @sim/tempnode.resc; runMacro $tests" --disable-xwt
renode sim/tempnode.resc        # interactive
```

## Power measurement
```
# Otii script — 60 s deep-sleep window, asserts avg <= 12 µA
python tools/power_log_parse.py --csv otii.csv --window 60 --max-avg-ua 12
```

## CLI on device (DEBUG strap shorted)
```
picocom -b 115200 /dev/ttyUSB0
> stat        # uptime, Vbat, last reset cause, FCnt
> tx          # force an uplink now
> sleep       # enter Stop2 immediately
> flash dpd   # send DPD opcode to NOR
> reset       # NVIC_SystemReset
```

## Provisioning (factory)
```
python tools/provision_keys.py --lot LOT-2026Q3-001 --count 500 \
       --out provisioning/lot_2026q3_001.csv
```

## Common diagnostics
```
# decode last 10 uplinks from ChirpStack MQTT
mosquitto_sub -h chirpstack.local -t 'application/+/device/+/event/up' -C 10 \
  | jq '.data | @base64d | fromjson?'

# read RTC backup register reset-cause tag via SWD
openocd -f ... -c "init; halt; mdw 0x40002850; exit"
```
