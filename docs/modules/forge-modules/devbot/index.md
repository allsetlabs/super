---
module: forge-modules/devbot
last_synced_commit: 3760714da939f9ead5fc9511d1b0f47f67e7f4f0
last_synced: 2026-06-10
---

# DevBot

## Overview

Personal assistant mobile app acting as a Claude Code terminal proxy — trigger development tasks from a phone anywhere. The app opens a web-based terminal (xterm.js) connected to a Node.js backend that manages Claude Code sessions via tmux, runs schedulers, hosts interactive chats with message queuing/branching, and supports self-contained plugins (baby-logs, lawn-care).

## Tech Stack

- **App:** Vite + React + TypeScript + xterm.js
- **Backend:** Node.js + TypeScript + Express (vite-node), WebSockets (ports 7750–7799)
- **DB:** Drizzle ORM + SQLite, database-per-plugin (`devbot.db`, `baby-logs.db`, `lawn-care.db`); Supabase for session persistence
- **Other:** Remotion (intro-video), tmux, Claude Code CLI workers (`--output-format=stream-json`)

## Architecture

```
devbot/
├── app/         # Web app (terminal UI)
├── backend/     # Express session manager + plugin router registry
├── reusables/   # Nested submodule of allsetlabs/forge, pinned older commit
├── supabase/    # Local Supabase (session persistence + migrations)
├── intro-video/ # Remotion intro video project
└── plugins/     # Plugin modules (baby-logs, lawn-care)
```

API reference: [devbot skill api.md](../../../.agents/skills/devbot/api.md) — full endpoint catalog (sessions, schedulers, interactive chats, companies, plugins, files, OCR, Claude Code config).

Key rules: never restart DevBot without explicit permission; every table carries `created_by/updated_by/settings` columns; optional fields go in the JSON `settings` column to avoid migrations.

## How to Run

- `make setup` / `make install` / `make start` (tmux session; app port **4005**, backend port **3100**)
- Backend only: `make run-dbb`

## Recent Changes

- `3760714` chore: adopt AGENTS.md standard (CLAUDE.md → AGENTS.md + symlink)
- `3efc791` refactor: remove global skill/command/agent installation (moved to super repo)
- `8172a31` chore: remove `.global` — skills/agents/commands now live in super repo
- `1940b43` feat: chat message queue with send-all UI (#6)
- `ca37b98` feat: persist chat stars in backend + dropdown padding fixes
- `53faf21`–`f40498e` feat(tvk): series of ECI election data refreshes (May 2026 counting rounds)

## Links

- Module [AGENTS.md](../../../forge-modules/devbot/AGENTS.md)
- [DevBot skill](../../../.agents/skills/devbot/SKILL.md) (API reference, CRUD patterns, worker patterns, plugin install, db-upgrade)
