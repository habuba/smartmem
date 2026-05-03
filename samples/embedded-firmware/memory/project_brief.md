# Project brief — tempnode

## What
Battery-powered outdoor temperature/humidity sensor node. Reports every 15 minutes over LoRaWAN (EU868 / US915 SKUs) to a customer-owned ChirpStack network server. No local UI. Field-serviceable only via UART debug header (under enclosure cover) and over-the-air FW update via LoRaWAN multicast (FUOTA, planned for v1.5).

## Why
Existing market solutions in the cold-chain monitoring niche either burn through CR123A cells in <18 months or require external power. Customers want install-and-forget for a full inspection cycle (5 years). Margin lives in not having to send a tech to swap batteries.

## Scope (v1.x firmware)
- Sample SHT40 every 15 min, batch 4 samples per uplink (1 hour cadence on air).
- Class A LoRaWAN, ADR enabled, confirmed uplinks every 24h only.
- Self-diagnostic: battery voltage, MCU temp, last reset cause, uptime — appended to first uplink after boot and once per day.
- DFU over UART for factory programming. OTA FUOTA stubbed but disabled.

## Out of scope
- BLE, WiFi, GPS.
- Local data logging beyond the 4-sample uplink batch.
- Encrypted-at-rest payload (LoRaWAN MIC + AppSKey is sufficient for the threat model).

## Stakeholders
- HW: in-house, board rev v1.3 frozen for production run #1 (2026 Q3).
- Cloud: customer-owned ChirpStack + Grafana. We don't operate it.
- FW: this repo.
