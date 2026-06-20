---
module: modules/memory
last_synced_commit: aa1dd10e2ecd718f64940b23013103d5643f3523
last_synced: 2026-06-20
---

# Memory

## Overview

A private **whole-life** memory store, captured conversationally from any session: personal life **and** work. An agent drafts a dated markdown entry with structured metadata (people, projects, tags, mood, location, summary) and an always-present category tag (`personal`/`work`/`automated`), gets explicit approval, then appends it. A day holds multiple entries, each a human-timestamped section. No app or database — plain markdown files read and written directly by AI agents, designed for later AI recall/filter (e.g. "happy memories with wife", "my work on seekr").

## Tech Stack

None — plain markdown files with YAML frontmatter. No build, dependencies, or services.

## Architecture

```
memory/
├── by_date/YYYY/MM/DD.md   # one file per day, many timestamped entries per file
└── docs/decisions/         # ADRs for memory conventions
```

Each daily file is YAML frontmatter holding the **day's union** of `date`/`people`/`projects`/`tags`/`mood`/`location`/`summary`, followed by one `### H:MM AM/PM — <category>` section per memory. Search/filter works by grepping frontmatter across `**/*.md` (including category tags like `work`) rather than a separate index — see [ADR 0001](../../../modules/memory/docs/decisions/0001-entry-layout-and-metadata.md). Daily entries live under `by_date/` ([ADR 0002](../../../modules/memory/docs/decisions/0002-by-date-directory-and-open-type-layout.md)); work is captured alongside personal life with a category tag ([ADR 0003](../../../modules/memory/docs/decisions/0003-capture-work-and-category-tag.md)); a day holds multiple timestamped sections ([ADR 0004](../../../modules/memory/docs/decisions/0004-multiple-timestamped-entries-per-day.md)).

## How to Run

`make setup` / `make install` / `make start` are no-ops — nothing to install or run.

## Recent Changes

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
- [Decision records](../../../modules/memory/docs/decisions/index.md)
