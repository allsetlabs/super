# 0004 — AGENTS.md guidance extracted into a `standards/` directory, with a repo-wide Standards section

**Date:** 2026-06-11
**Status:** Accepted (amended by [0005](0005-retire-module-standards-to-follow.md) for `module-standards-to-follow.md`'s retirement)

## Decision

- New directory `.agents/skills/super/standards/` holds reference docs that any module/subdirectory must follow:
  - `decision-records.md` (moved from `.agents/skills/super/decision-records.md`, see [0003](0003-pre-commit-decision-record-check.md))
  - `agents-md.md` (new — the "AGENTS.md that teaches judgment" guidance extracted from `module-standards-to-follow.md`)
- `module-standards-to-follow.md` now points to `standards/agents-md.md` for AGENTS.md structure/content guidance instead of embedding it.
- The super repo's root `AGENTS.md` gains a `## Standards` section — a table linking to `module-standards-to-follow.md`, `standards/agents-md.md`, and `standards/decision-records.md`, each with a "when to read it" note — and states that every module/subdirectory must follow these to be considered part of the super repo.
- The numbered `## Rules` section no longer embeds these file paths directly; rules 1.1 and 5.2 now reference the Standards section by name instead.
- The super skill's `SKILL.md` reference table is updated to the new paths and gains a row for `agents-md.md`.

## Why

The set of "things every module/subdirectory must follow" was scattered: some lived as headings inside `module-standards-to-follow.md`, some as inline file-path references buried in numbered rules in root `AGENTS.md`. As that set grows (decision records, AGENTS.md structure, and likely more), a dedicated `standards/` directory plus a single repo-wide index makes it discoverable, and gives agents one place to check before creating or updating an `AGENTS.md` anywhere in the tree — not just during module onboarding.

## How it's maintained

- New cross-cutting standards that any module/subdirectory must follow go in `.agents/skills/super/standards/`, with a row added to root `AGENTS.md`'s `## Standards` table and to `SKILL.md`'s reference table.
- `module-standards-to-follow.md` stays the top-level onboarding/audit checklist and links out to `standards/*.md` for deep-dives.
