---
module: modules/memory
last_synced_commit: 5003821829de483bc498672881f03354c2d102e2
last_synced: 2026-06-13
---

# Memory

## Overview

A private daily memory store, captured conversationally: the user describes their day, an agent drafts a dated markdown entry with structured metadata (people, tags, mood, location, summary), gets explicit approval, then saves it. No app or database — plain markdown files read and written directly by AI agents, designed for later AI recall/analysis (e.g. "happy memories with wife").

## Tech Stack

None — plain markdown files with YAML frontmatter. No build, dependencies, or services.

## Architecture

```
memory/
├── YYYY/MM/DD.md       # one file per day, created on demand
└── docs/decisions/     # ADRs for memory conventions
```

Each entry is YAML frontmatter (`date`, `people`, `tags`, `mood`, `location`, `summary`) followed by a markdown narrative. Search works by grepping frontmatter across `**/*.md` rather than a separate index — see [ADR 0001](../../../modules/memory/docs/decisions/0001-entry-layout-and-metadata.md).

## How to Run

`make setup` / `make install` / `make start` are no-ops — nothing to install or run.

## Recent Changes

- `5003821` docs: onboard journal module with AGENTS.md and entry conventions
- `cd0696f` Initial commit

## Links

- Module [AGENTS.md](../../../modules/memory/AGENTS.md)
- [Decision records](../../../modules/memory/docs/decisions/index.md)
