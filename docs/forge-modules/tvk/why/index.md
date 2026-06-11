---
module: forge-modules/tvk/why
last_synced_commit: abfc7ef13189a87be96ee14dfc854d23a135574e
last_synced: 2026-06-10
---

# Why TVK

## Overview

Data-driven manifesto platform explaining why TVK is the right choice for Tamil Nadu. Bold "fire-fueled" tone, every statistic linked to a government source (data.gov.in, NCRB, UDISE+), before/after comparisons per ruling term, bilingual Tamil/English, mobile-first. Deployed to GitHub Pages from main.

## Tech Stack

React + Vite + TypeScript, GSAP (ScrollTrigger), Three.js / React Three Fiber, Recharts/D3, react-i18next, `@allsetlabs/reusable` from `../../forge`. Brand: TVK Blue `#1B4FD8`, Gold `#F5C518`, red fire accents.

## Architecture

```
why-tvk/
├── web/       # React + Vite site (the active codebase)
├── mobile/    # Reserved
├── backend/   # Reserved
├── .agents/   # AI agent definitions (rules in .agents/CONVENTIONS.md)
└── .board/    # Agent communication hub (task board + feedback JSON)
```

Agent-managed project — same board/feedback workflow as namma ([SCHEMA.md](../../../../forge-modules/tvk/why/.board/SCHEMA.md)).

## How to Run

`make setup` / `make install` / `make start` → web on port **4006**.

## Recent Changes

- `abfc7ef` chore: adopt AGENTS.md standard
- `664e374` chore: update forge ref path for `tvk/` nesting
- `c77f4e9` initial import from devbot-superrepo

## Links

- Module [AGENTS.md](../../../../forge-modules/tvk/why/AGENTS.md)
