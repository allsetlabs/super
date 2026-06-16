# 0003 — Decision-record format moved to its own reference doc, with a pre-commit check

**Date:** 2026-06-10
**Status:** Accepted

## Decision

- The ADR format/placement guidance previously embedded in `.agents/skills/super/module-standards-to-follow.md` (the "docs/decisions/" section) moved to its own file: `.agents/skills/super/decision-records.md`.
- `module-standards-to-follow.md` now just points to it (the standard — every module has `docs/decisions/` — is still checked during onboarding/auditing).
- The super skill's `SKILL.md` reference table lists `decision-records.md`.
- The super repo's root `AGENTS.md` gains a pre-commit step (5.2): before committing, check whether this session made a non-obvious, hard-to-reverse decision and, if so, record it as an ADR per `decision-records.md` before/with the dependent change.

## Why

[0002](0002-per-module-decision-records.md) defined the ADR format and placement rules but only referenced them from module onboarding/auditing — there was no trigger to record a decision _during_ normal work, so ADRs were easy to forget in the moment they're made. Splitting the format into its own reference doc lets it be linked from both the onboarding standard and the per-commit checklist without duplication.

## How it's maintained

- `decision-records.md` is the single source of truth for ADR format, placement, and the pre-commit check.
- Root `AGENTS.md` rule 5.2 and `module-standards-to-follow.md` both link to it.
