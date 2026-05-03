# Product context — tempnode

## Who deploys it
Cold-chain logistics integrators. They buy nodes in lots of 500-5000, provision DevEUI/AppKey from a CSV we ship with each lot, mount the node inside refrigerated trailers or warehouse cells, and walk away.

## Operational reality
- No tech ever opens the enclosure after install. If it dies, it's replaced, not repaired.
- Network coverage is assumed but not guaranteed. Node must tolerate 72h of no-ack without behavioral change (just keep trying, back off ADR).
- Temperature swings from -25C (frozen storage) to +45C (loading dock in summer) are normal. CR123A capacity drops ~30% at -20C — power budget assumes worst-case cold.
- RF environment is hostile: metal enclosures, dense node populations (often 200+ nodes per gateway).

## What "good" looks like in the field
- 5-year median life on a single CR123A (1500 mAh nominal, ~1000 mAh usable cold).
- <0.1% lost-uplink rate at SF12 with -130 dBm RSSI.
- Zero field firmware updates required for the v1.x product line.

## What kills nodes in the field (known from v0 pilot)
1. Brown-out during LoRa TX at low battery + cold (fixed in v1.2 with reservoir cap + BOR threshold tune).
2. SPI flash leakage current (open — see active_context).
3. Whisker/condensation shorts on the antenna matching network (HW issue, conformal coat in v1.3).
