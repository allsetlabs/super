---
name: devbot
description: DevBot module skill — backend API reference, CRUD route patterns, Claude worker patterns, plugin installation, database migrations (db-upgrade), and company-project scaffolding. Use when working anywhere in forge-modules/devbot (sessions, schedulers, interactive chats, plugins, baby logs, lawn care, uploads) or when the user mentions DevBot.
---

# DevBot

Entry point for everything DevBot. Load only the topic file you need. If invoked directly (e.g. `/devbot`) with no task or topic, ask the user which topic to load (AskUserQuestion with the options below) — do not guess.

| Topic                  | File                                     | When to load                                                                                                                                                                   |
| ---------------------- | ---------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| API reference          | [api.md](api.md)                         | Calling or integrating with DevBot backend APIs: sessions, schedulers, chats, companies, baby logs, lawn care, weather, videos, files, uploads, OCR, plans, Claude Code config |
| CRUD route patterns    | [crud-patterns.md](crud-patterns.md)     | Creating or editing route files in `forge-modules/devbot/backend/src/routes/`                                                                                                  |
| Worker patterns        | [worker-patterns.md](worker-patterns.md) | Editing Claude CLI worker files in `forge-modules/devbot/backend/src/lib/` (spawning, stream-json parsing, persistence, cleanup)                                               |
| Plugin install         | [plugin-install.md](plugin-install.md)   | Installing a DevBot plugin from a GitHub URL or local path                                                                                                                     |
| Database upgrade       | [db-upgrade.md](db-upgrade.md)           | Applying pending Supabase migrations to the local DevBot database without losing data                                                                                          |
| Create company project | [create-project.md](create-project.md)   | Scaffolding a new AI-agent-managed company project with CEO agent and scheduler                                                                                                |

Module docs live in `forge-modules/devbot/AGENTS.md` (architecture, database rules, autonomy rules).
