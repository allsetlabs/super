---
module: forge-modules/tvk/2026
last_synced_commit: d80dbe65b85c22ef85893fee3977f8dbb0e68ba5
last_synced: 2026-06-10
---

# TVK 2026 Election Dashboard

## Overview

Frontend-only SPA tracking TVK (Tamilaga Vettri Kazhagam) results for the Tamil Nadu Assembly 2026 election with enriched candidate profiles. Data files in `src/data/` are edited directly by a DevBot scheduler scraping ECI (`results.eci.gov.in`); Vite hot-reloads on each update. No backend.

## Tech Stack

Vite + React + TypeScript + React Router (HashRouter for GitHub Pages), `@allsetlabs/forge` from `../../forge`.

## Architecture

```
src/
├── data/
│   ├── election.ts        # Aggregate stats, party totals, vote share
│   ├── constituencies.ts  # 234 per-constituency result rows
│   └── candidates.ts      # Enriched profiles (bio, education, net worth)
├── pages/                 # Dashboard (/), CandidateList (/candidates), CandidateProfile (/candidates/:id)
└── components/
```

Scheduler notes (ECI selectors, affidavit sources) live in the module's `tvk-info.md` — read before each scheduler run.

## How to Run

`make setup` / `make install` / `make start` → port **4030**. Deployed to GitHub Pages with base `/tvk-2026/`.

## Recent Changes

- `d80dbe6` chore: adopt AGENTS.md standard
- `8e705f5` chore: update forge ref path for `tvk/` nesting
- `f81f11f` data: scheduler fills real candidate names from ECI results
- `12892a5` fix: always use `/tvk-2026/` base for GitHub Actions asset paths
- `38fd0b2` fix: HashRouter for GitHub Pages compatibility

## Links

- Module [AGENTS.md](../../../../forge-modules/tvk/2026/AGENTS.md)
