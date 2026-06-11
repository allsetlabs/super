---
module: forge-modules/tvk/manifesto
last_synced_commit: db0e5f2b4b0d3d45c946995344d74ddb8211dff2
last_synced: 2026-06-10
---

# TVK Manifesto

## Overview

High-performance static site showcasing TVK's party manifesto, leadership, district member directories, and governance impact comparisons. Cinematic GSAP animations, Three.js 3D hero, Remotion-style data visualizations, bilingual English/Tamil, dark/light theme. Deployed as static files to Vercel/Netlify.

## Tech Stack

Astro (SSG) + React components + Tailwind CSS v4 + GSAP + Three.js + Remotion.

## Architecture

```
src/
├── components/   # hero/, manifesto/, members/, stats/, common/
├── layouts/ • pages/   # Astro layouts and routes
├── i18n/         # en.json, ta.json
├── data/         # Static JSON (manifesto, members, stats)
└── lib/          # Animation helpers, theme utils
```

Developed by two DevBot schedulers: **tvk-ceo** (hourly, product manager — maintains `CEO-TASKS.md`, no code) and **tvk-developer** (every 6h, implements top pending tasks and tests in Chrome).

## How to Run

`make setup` / `make install` / `make start` → port **4010**.

## Recent Changes

- `db0e5f2` chore: adopt AGENTS.md standard
- `bb9bd7d` chore: update forge ref path for `tvk/` nesting
- `74b89cc` initial import from devbot-superrepo

Status: foundation phase — scaffolded, base layout/theme/i18n still pending (see module `CEO-TASKS.md`).

## Links

- Module [AGENTS.md](../../../../forge-modules/tvk/manifesto/AGENTS.md)
