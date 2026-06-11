# agents-md — AGENTS.md That Teaches Judgment

Read this before creating or updating an `AGENTS.md` (or its `CLAUDE.md` symlink) in this repo or any module/subdirectory.

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
- Tables for rules and guidance — use a numbered or bulleted list instead; lists are easier for humans to scan.

Plus a `CLAUDE.md` symlink pointing to it (`ln -s AGENTS.md CLAUDE.md`).

Keep it lean — every line consumes context on every chat in that module. No duplicate info from the super repo's root `AGENTS.md`.
