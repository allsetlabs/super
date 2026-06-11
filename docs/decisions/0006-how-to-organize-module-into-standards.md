# 0006 — `how-to-organize-module.md` moved into `standards/`, referenced from AGENTS.md's Standards section

**Date:** 2026-06-11

**Status:** Accepted

## Decision

- `.agents/skills/super/how-to-organize-module.md` moved to `.agents/skills/super/standards/how-to-organize-module.md`.
- Root `AGENTS.md`'s `## Standards` list gains a new item 1, "Module organization", pointing to the new path.
- `## Rules` item 1 ("Adding a module") no longer embeds the file path directly — it now reads "Categorize and place it per the Standards above", mirroring how item 1.1 already references the Standards section.
- `SKILL.md`'s reference table path updated to `standards/how-to-organize-module.md`.

## Why

Continues the consolidation from [0004](0004-standards-directory.md) and [0005](0005-retire-module-standards-to-follow.md): every reference doc an agent must read before acting on the super repo's structure now lives under `standards/`, with a single entry point in root `AGENTS.md`'s `## Standards` table. The inline file-path reference in `## Rules` item 1 was the same pattern 0004 already removed for the other standards docs.

## How it's maintained

- New cross-cutting standards continue to go in `.agents/skills/super/standards/`, with an entry in root `AGENTS.md`'s `## Standards` list and a row in `SKILL.md`'s reference table.
