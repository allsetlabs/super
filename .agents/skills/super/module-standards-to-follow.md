# module-standards-to-follow — What Every Module Must Have

Apply this when onboarding a new module and when auditing existing ones (the `/fix-auto-fixable-standards` command checks these too).

## Makefile with 3 targets

| Target | Purpose |
|--------|---------|
| `make setup` | System-level deps (Node, Python, tmux). Idempotent — check before installing. |
| `make install` | Project-level deps (`npm install`, `pip install`, etc.) |
| `make start` | Start all services in a tmux session. Single entry point. |

Hardcode ports as Makefile variables at the top. Never in `.env` files.

## AGENTS.md that teaches judgment

Every module must have an `AGENTS.md` that helps an AI agent make good decisions in that module. It should document **intent, conventions, commands, and danger zones** — not a complete inventory of files the agent can discover with `rg`/`find`.

Recommended structure:

```md
# <Project Name>

## Purpose
What this project is for, in 2-4 sentences.

## Mental Model
How the major pieces work together, including external services and runtime flow.

## Where Things Go
Short directory guide with ownership/routing rules. Explain why a directory matters; do not paste a full tree unless the structure is unusual.

## Development Commands
Install, lint, type-check, test, build, and start commands. Include the command agents should run before calling work done.

## Architecture Conventions
Database patterns, API patterns, component patterns, naming rules, file-size rules, and dependency rules that are easy to violate.

## Hard Rules
Things agents must always do or must never do. Examples: never restart a live worker, never edit generated files, never write plugin UI in the app shell.

## Testing Expectations
Automated checks and any required manual/visual checks.

## Related Docs
Links to deeper docs, API references, or subsystem `AGENTS.md`/`CLAUDE.md` files.
```

Optional sections:

- `## Current Capabilities` — use instead of `Progress` when the information is stable and maintained.
- `## Known Gaps` — only for active, accurate limitations that affect agent decisions.
- `## Project-Specific Topics` — domain-specific rules that do not fit the standard headings.

Avoid:

- Long directory trees with no guidance. The agent can read the filesystem.
- Stale progress logs, roadmaps, or TODO dumps. Put plans in the project tracker/docs instead.
- Repeating rules from the super repo root `AGENTS.md`.
- Generic advice like "write clean code" unless it maps to a concrete local convention.

Plus a `CLAUDE.md` symlink pointing to it (`ln -s AGENTS.md CLAUDE.md`).

Keep it lean — every line consumes context on every chat in that module. No duplicate info from the super repo's root AGENTS.md.

## docs/decisions/ — decision records

Every module — including the super repo itself — has a `docs/decisions/` directory for Architecture Decision Records (ADRs). New modules get an empty one (with `index.md`) during onboarding.

- **Module-specific decisions** (architecture, library choices, conventions for that module's own code) go in that module's own `docs/decisions/`.
- **Super-repo decisions** (cross-module standards, super repo organization/conventions) go in the super repo's `docs/decisions/`.

### Format

- One file per decision: `NNNN-short-title.md` — 4-digit zero-padded sequence number + short kebab-case title. The filename *is* the title; the context, decision, rationale, and how it's maintained go in the file body, not the filename.
- `index.md` lists all decisions in that directory: number, title (linked), date — newest first.

### When to record one

A non-obvious, hard-to-reverse choice for that module (or, in the super repo, a cross-module convention) — e.g. database/library choice, directory layout, API pattern. Skip routine implementation details.

## If the module has a backend

It must have an AI-readable API reference doc — see [sync-api.md](sync-api.md) for location and format.
