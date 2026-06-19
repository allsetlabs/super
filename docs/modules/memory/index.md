---
module: modules/memory
last_synced_commit: 5003821829de483bc498672881f03354c2d102e2
last_synced: 2026-06-16
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

- `5003821` docs: onboard journal module with AGENTS.md and entry conventions
- `cd0696f` Initial commit

## Links

- Module [AGENTS.md](../../../modules/memory/AGENTS.md)
- [Decision records](../../../modules/memory/docs/decisions/index.md)
