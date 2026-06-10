# module-standards-to-follow — What Every Module Must Have

Apply this when onboarding a new module and when auditing existing ones (the `/fix-auto-fixable-standards` command checks these too).

## Makefile with 3 targets

| Target | Purpose |
|--------|---------|
| `make setup` | System-level deps (Node, Python, tmux). Idempotent — check before installing. |
| `make install` | Project-level deps (`npm install`, `pip install`, etc.) |
| `make start` | Start all services in a tmux session. Single entry point. |

Hardcode ports as Makefile variables at the top. Never in `.env` files.

## AGENTS.md with these headings

```
## Goal
## Description
## Architecture
## Progress
## <Project-Specific Topics>
```

Plus a `CLAUDE.md` symlink pointing to it (`ln -s AGENTS.md CLAUDE.md`).

Keep it lean — every line consumes context on every chat in that module. No duplicate info from the super repo's root AGENTS.md.

## If the module has a backend

It must have an AI-readable API reference doc — see [sync-api.md](sync-api.md) for location and format.
