---
module: forge-modules/seekr
last_synced_commit: c6a92cc0412ebd32c547557b10ba449ed008191a
last_synced: 2026-06-10
---

# Seekr

## Overview

Personal career autopilot — automates the job search lifecycle: application tracking (Gmail integration), AI resume tailoring, interview prep, and cross-platform notifications. Multi-platform suite (web, Chrome extension, Electron desktop, Capacitor mobile) connected to one FastAPI backend via WebSocket.

## Tech Stack

- **Frontends:** React 19 + Vite + TypeScript (+ Electron for desktop, Capacitor for mobile, Manifest V3 for extension); all use `@allsetlabs/reusable` from `../../forge`
- **Backend:** Python 3.12 + FastAPI + SQLAlchemy + PostgreSQL (`seekr_db`); Anthropic API for resume AI; multi-provider TTS/STT (edge, openai, elevenlabs, google, wispr)

## Architecture

```
seekr/
├── web/        # Job dashboard + AI resume builder with voice
├── extension/  # Chrome extension (resume tailoring, challenge capture, Cmd+Q hotkey)
├── desktop/    # Electron background app (solution display off-screen-share)
├── mobile/     # Capacitor iOS/Android (notifications, quick actions)
└── backend/    # FastAPI + PostgreSQL (auth, resumes, settings, chat, TTS/STT)
```

API reference: [seekr skill api.md](../../../.agents/skills/seekr/api.md) — auth (Google OAuth + dev email/password), resumes, user settings, AI chat, TTS/STT.

## How to Run

`make setup` / `make install` / `make start` (starts everything in tmux; auto-creates PostgreSQL `seekr_db`). Ports: web **5173**, extension **4002**, desktop **4003**. Individual targets: `make run-web|run-extension|run-desktop|run-mobile|run-backend|run-db`. Env via `make setup-env` (`ANTHROPIC_API_KEY`, `OPENAI_API_KEY`, `GOOGLE_CLIENT_ID`, `JWT_SECRET_KEY`).

## Recent Changes

- `c6a92cc` chore: adopt AGENTS.md standard, removed stale `docs/` folder (5 outdated scaffolding docs)
- `7578899` chore: update component ref to `file:../../forge`
- `407d384` fix: code quality improvements

## Links

- Module [AGENTS.md](../../../forge-modules/seekr/AGENTS.md)
- [Seekr skill](../../../.agents/skills/seekr/SKILL.md) (video/meme tooling + API reference)
