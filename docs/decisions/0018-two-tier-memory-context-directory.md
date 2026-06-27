# 0018 — Two-tier memory: hot cache + deep `context/` directory

**Date**: 2026-06-27
**Status**: Accepted

## Context

The memory skill (`modules/memory/`) previously only covered journal-style dated entries (`by_date/YYYY/MM/DD.md`). It had no structure for workplace context — people, projects, acronyms, and internal terminology — making Claude unable to decode shorthand like "ask todd about the PSR for phoenix" without the user providing full context each time.

The Anthropic knowledge-work-plugins memory-management skill (skills.sh) demonstrated a two-tier pattern that solves this, separating frequently-needed context (hot cache) from the full knowledge base (deep memory).

## Decision

Extend the memory module with a `context/` directory alongside `by_date/`, organized as:

```
modules/memory/
  by_date/              ← existing journal entries, unchanged
  context/
    index.md            ← hot cache: top ~30 people, terms, active projects (~100 lines max)
    glossary.md         ← full decoder ring: all terms, acronyms, nicknames, codenames
    people/             ← one file per person with full profile
    projects/           ← one file per project with details
    company.md          ← teams, tools, processes
```

Lookup is tiered: `context/index.md` → `context/glossary.md` → `context/people/` or `context/projects/` → ask user.

## Rationale

- The hot cache covers ~90% of daily decoding at a glance without reading many files.
- The glossary allows unlimited growth without cluttering the hot cache.
- The tiered lookup matches how a human colleague would use working memory vs. reference docs.
- Separating `context/` from `by_date/` keeps the journal unmodified and the context queryable independently.
- `context/index.md` as the hot-cache filename is consistent with ADR 0017 (index.md as canonical).

## Consequences

- The `context/` directory does not yet exist in `modules/memory/` — it is created on first use when the memory skill writes a context entry.
- Promotion/demotion rules (move items to hot cache when used frequently; demote when stale) require judgment at write time.
- The hot cache must be kept under ~100 lines; the skill enforces this as a hard rule.
- Cloud-specific bootstrapping (scanning calendar/email to auto-populate context) is explicitly excluded — context is populated manually as the user mentions terms.
