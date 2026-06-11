---
module: forge-modules/tn-crime
last_synced_commit: 2722335be3e202b5266d4f20ab4c2be67a77bb78
last_synced: 2026-06-10
---

# TN Crime Analytics

## Overview

Single-page dashboard exposing Tamil Nadu crime trends under the DMK government (May 2021–2026) across three domains: drugs, murder, and crimes against women. Frontend only — static data, no backend, forced dark mode.

## Tech Stack

Vite + React + TypeScript + Tailwind CSS, `@allsetlabs/reusable` from `../forge`.

## Architecture

```
src/
├── App.tsx                          # Root layout — header, tabs, dark mode
├── components/                      # DrugSection, MurderSection, CrimesAgainstWomenSection
├── data/crimes.ts                   # Static crime statistics (edit here to update data)
└── main.tsx
```

No routing — single page with tabs. Dark mode forced by adding `dark` class to `#reusables-app-root`.

## How to Run

`make setup` / `make install` / `make start` → port **4020**.

## Recent Changes

- `2722335` chore: adopt AGENTS.md standard
- `c732c3a` chore: update component ref to `file:../forge`
- `56f24c7` data: year-wise murders, POCSO 2024 surge, 8 drug cases

## Links

- Module [AGENTS.md](../../../forge-modules/tn-crime/AGENTS.md)
