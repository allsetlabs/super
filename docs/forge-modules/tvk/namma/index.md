---
module: forge-modules/tvk/namma
last_synced_commit: 38e4161802e0c2dece247f6307cb22c965c4219a
last_synced: 2026-06-10
---

# Namma TVK

## Overview

Bilingual (Tamil/English) political manifesto website presenting data-backed governance analysis and TVK's vision for Tamil Nadu — before/after comparisons per ruling term, sourced statistics only (government portals, NCRB, UDISE+, PRS India). Mobile-first and heavily animated. Deployed to GitHub Pages from main.

## Tech Stack

React + Vite + TypeScript, GSAP (ScrollTrigger), Three.js, react-i18next, `@allsetlabs/forge` from `../../forge`.

## Architecture

```
namma-tvk/
├── web/       # React + Vite site (the active codebase)
├── mobile/    # Reserved (PWA/native)
├── backend/   # Reserved — currently empty (.gitkeep only), no API yet
├── .agents/   # Agent definitions; behavior rules in .agents/CONVENTIONS.md
└── .board/    # Agent task board (companyboard.json, user/investor feedback)
```

Agent-managed project: autonomous AI agents (CEO + developers with Tamil first names) coordinate via `.board/`. Feedback goes in `.board/user-feedback.json` / `investor-feedback.json` per `.board/SCHEMA.md`.

## How to Run

`make setup` / `make install` / `make start`. Ports: web **4010**, backend **3110** (reserved), mobile **4011**.

## Recent Changes

- `38e4161` chore: adopt AGENTS.md standard
- `fd6409e` chore: update forge ref path for `tvk/` nesting
- `8516dfc` initial import from devbot-superrepo

## Links

- Module [AGENTS.md](../../../../forge-modules/tvk/namma/AGENTS.md)
