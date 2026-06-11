---
module: forge-modules/meme-vault
last_synced_commit: d1e40b804eb273d41a99ad5907e08bd65892aeb4
last_synced: 2026-06-10
---

# Meme Vault

## Overview

Next.js app for collecting, processing, and publishing meme clips from YouTube through an automated media pipeline (download → caption burn → GIF → GitHub storage → Instagram Reel → Supabase metadata). A background worker processes queued jobs; a cron task syncs GitHub storage with Supabase metadata.

## Tech Stack

Next.js (app router) + React + TypeScript + Tailwind CSS, `@allsetlabs/reusable` from `../forge`, Supabase (DB + auth + storage), GitHub API, Instagram Graph API, ffmpeg/yt-dlp via standalone Node scripts.

## Architecture

```
meme-vault/
├── src/app/          # Pages + API routes (api/clips, api/auth/google-login)
├── src/{components,lib,types}/
├── worker/           # Background job processor (polls jobs table)
├── cron/             # GitHub → Supabase storage sync
├── supabase/         # Local Supabase config and migrations
└── independent_node_skills/  # Standalone media-processing scripts
```

API reference: [meme-vault skill api.md](../../../.agents/skills/meme-vault/api.md) — clips CRUD with async job queue, Google login.

## How to Run

`make setup` / `make install` / `make start` → app on port **3000**; auto-starts local Supabase (`npm run db:start`). Requires `.env.development` with Supabase/GitHub/Instagram credentials.

## Recent Changes

- `d1e40b8` chore: adopt AGENTS.md standard
- `6f7ab9f` chore: update component ref to `file:../forge`
- `e48d0b3` fix: code quality improvements

## Links

- Module [AGENTS.md](../../../forge-modules/meme-vault/AGENTS.md)
- [Meme Vault skill](../../../.agents/skills/meme-vault/SKILL.md) (delete-meme, API reference)
- Creation tooling lives in the [seekr skill](../../../.agents/skills/seekr/SKILL.md)
