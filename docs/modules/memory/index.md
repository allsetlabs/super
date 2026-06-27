---
module: modules/memory
last_synced_commit: ca39131ba2321ccb0e2a561a45d207abf76ab09f
last_synced: 2026-06-27
---

# Memory

## Overview

A private **whole-life** memory store, captured conversationally from any session: personal life **and** work. The current format is two-tier: `AGENTS.md` is a compact hot cache for the most-used people, terms, projects, and preferences, while `context/` holds deeper glossary and profile data. The dated journal stays in `by_date/`, with structured metadata (people, projects, tags, mood, location, summary) and timestamped sections per day. No app or database — plain markdown files read and written directly by AI agents, designed for later AI recall/filter.

## Tech Stack

None — plain markdown files with YAML frontmatter. No build, dependencies, or services.

## Architecture

```
memory/
├── AGENTS.md                  # hot cache for common people/terms/projects/preferences
├── by_date/YYYY/MM/DD.md      # one file per day, many timestamped entries per file
├── context/
│   ├── glossary.md            # full decoder ring
│   ├── company.md             # work/workspace context
│   ├── people/*.md            # per-person notes
│   └── projects/*.md          # per-project notes
└── docs/decisions/            # ADRs for memory conventions
```

Each daily file is YAML frontmatter holding the **day's union** of `date`/`people`/`projects`/`tags`/`mood`/`location`/`summary`, followed by one `### H:MM AM/PM — <category>` section per memory. Search/filter still works from plain markdown, but now decoding can short-circuit through the hot cache in `AGENTS.md` and then the richer `context/` files before falling back to raw daily entries. Daily entries live under `by_date/` ([ADR 0002](../../../modules/memory/docs/decisions/0002-by-date-directory-and-open-type-layout.md)); work is captured alongside personal life with a category tag ([ADR 0003](../../../modules/memory/docs/decisions/0003-capture-work-and-category-tag.md)); a day holds multiple timestamped sections ([ADR 0004](../../../modules/memory/docs/decisions/0004-multiple-timestamped-entries-per-day.md)); the hot-cache role of `AGENTS.md` is restored in [ADR 0006](../../../modules/memory/docs/decisions/0006-agents-md-is-hot-cache-and-skill-keeps-the-rules.md).

## How to Run

`make setup` / `make install` / `make start` are no-ops — nothing to install or run.

## Recent Changes

- `working tree` memory: restore hot-cache/context structure from existing dated entries
- `aa1dd10` memory: record Forge Dialog mobile viewport fix
- `3bc4f0d` memory: record DevBot STT pipeline using local Ollama
- `a23f285` memory: record DevBot chat progress and summary integration
- `9d2b4ea` memory: record chat-summary rename to summarize-chat
- `c0fad92` memory: record stop-hook rename
- `3ed823f` memory: record journal-to-memory stop-hook rename
- `77d7e2a` memory: record shared STT learning file move
- `f18b0ca` memory: record DevBot session progress tracking
- `0b99b29` memory: record Kimi and Claude migration work
- `74eb3cd` memory: record DevBot chat-header cleanup
- `6d2969c` memory: record DevBot code-changes indicator
- `fd5dc56` memory: correct land deed entry
- `4122418` memory: record land deed review
- `0b23cda` memory: record DevBot dirty-code indicator design
- `cd3d5e2` memory: record DevBot pause and resume UI cleanup
- `8115123` memory: record cross-platform memory-agent investigation
- `5f7d7c7` docs: add work memories and timestamped multi-entry conventions
- `0917c35` memory: record DevBot voice-triggered send feature
- `40b4b30` docs: update memory decision index
- `0198994` chore: move daily entries under `by_date/`

## Links

- Module [AGENTS.md](../../../modules/memory/AGENTS.md)
- [Glossary](../../../modules/memory/context/glossary.md)
- [Decision records](../../../modules/memory/docs/decisions/index.md)
