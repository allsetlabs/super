---
name: devbot
description: DevBot module skill — backend API reference, CRUD route patterns, Claude worker patterns, plugin installation, and company-project scaffolding. Use when working anywhere in forge-modules/devbot (sessions, schedulers, interactive chats, plugins, baby logs, lawn care, uploads) or when the user mentions DevBot.
---

# DevBot

Entry point for everything DevBot. Load only the topic file you need:

| Topic | File | When to load |
|-------|------|--------------|
| Backend API reference | [backend.md](backend.md) | Interacting with DevBot services: sessions, schedulers, chats, commands, baby logs, lawn care, weather, videos, uploads, plans, grocery lists |
| CRUD route patterns | [crud-patterns.md](crud-patterns.md) | Creating or editing route files in `forge-modules/devbot/backend/src/routes/` |
| Worker patterns | [worker-patterns.md](worker-patterns.md) | Editing Claude CLI worker files in `forge-modules/devbot/backend/src/lib/` (spawning, stream-json parsing, persistence, cleanup) |
| Plugin install | [plugin-install.md](plugin-install.md) | Installing a DevBot plugin from a GitHub URL or local path |
| Create company project | [create-project.md](create-project.md) | Scaffolding a new AI-agent-managed company project with CEO agent and scheduler |

Module docs live in `forge-modules/devbot/CLAUDE.md` (architecture, database rules, autonomy rules).
