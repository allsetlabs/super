---
module: modules/forge-modules/devbot
last_synced_commit: 0e074c9fe7adbb7c3072aaded3ec80e69a3c97ea
last_synced: 2026-06-19
---

# DevBot

## Overview

Personal assistant mobile app acting as a Claude Code terminal proxy — trigger development tasks from a phone anywhere. The app opens a web-based terminal (xterm.js) connected to a Node.js backend that manages Claude Code sessions via tmux, runs schedulers, hosts interactive chats with message queuing/branching, and supports self-contained plugins (baby-logs, lawn-care).

## Tech Stack

- **App:** Vite + React + TypeScript + xterm.js
- **Backend:** Node.js + TypeScript + Express (vite-node), WebSockets (ports 7750–7799)
- **DB:** Drizzle ORM + SQLite, database-per-plugin (`devbot.db`, `baby-logs.db`, `lawn-care.db`); Supabase for session persistence
- **Component library:** `@allsetlabs/forge` (sibling `forge-modules/forge`)
- **Other:** Remotion (intro-video), tmux, Claude Code CLI workers (`--output-format=stream-json`), openai-whisper (local STT)

## Architecture

```
devbot/
├── app/         # Web app (terminal UI)
├── backend/     # Express session manager + plugin router registry
├── supabase/    # Local Supabase (session persistence + migrations)
├── intro-video/ # Remotion intro video project
└── plugins/     # Plugin modules (baby-logs, lawn-care)
```

API reference: [devbot skill api.md](../../../../.agents/skills/devbot/api.md) — full endpoint catalog (sessions, schedulers, interactive chats, companies, plugins, files, OCR, Claude Code config, STT).

Key rules: never restart DevBot without explicit permission; every table carries `created_by/updated_by/settings` columns; optional fields go in the JSON `settings` column to avoid migrations.

## How to Run

- `make setup` / `make install` / `make start` (tmux session; app port **4005**, backend port **3100**)
- Backend only: `make run-dbb`

## Recent Changes

- `0e074c9` revert: remove code changes indicator from chat list
- `efb39e8` chore: remove unused pause button and unsafe mode banner from interactive chat
- `6570caa`/`de9fb3c` feat: voice-triggered send/queue via Web Speech API (say "send" or "queue")
- `d7388765` feat: local STT with whisper + Web Speech live preview + per-user learning system (`/api/stt`)
- `9df08145` fix: working directory dropdown opens upward with wrapping text
- `15af218d` fix: remove stale maxTurns references after schema cleanup
- `d659ecbf` chore: remove unused drawer components (HooksDrawer, McpServersDrawer, KeybindingsDrawer, ChatAllowedToolsDrawer, ChatMaxTurnsDrawer, ToolHistoryDrawer)
- `06db66fa` refactor: remove Resumable UI from chat list
- `15365a96` feat: swipe-left to archive on chat list
- `5d8e3de7` style: wrap working directory paths instead of truncating
- `835f15cf` fix: compute working directory default/root flags in backend per-request
- `282fcb0e` chore: finish reusables→forge rename; adopt AGENTS.md standard across all packages

## Links

- Module [AGENTS.md](../../../../modules/forge-modules/devbot/AGENTS.md)
- [DevBot skill](../../../../.agents/skills/devbot/SKILL.md) (API reference, CRUD patterns, worker patterns, plugin install, db-upgrade)
