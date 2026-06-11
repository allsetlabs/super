# 0005 — `module-standards-to-follow.md` retired; Makefile standard moved to `standards/`

**Date:** 2026-06-11
**Status:** Accepted

## Decision

- After [0004](0004-standards-directory.md) extracted the AGENTS.md and decision-records guidance, `module-standards-to-follow.md` only had two things left: the Makefile targets table and a one-line pointer to `sync-api.md` for the backend API reference doc. The file is now retired.
- `.agents/skills/super/standards/makefile.md` (new, moved from `module-standards-to-follow.md`) holds the Makefile standard, rewritten as a numbered list instead of a table.
- The backend API reference doc requirement is **not** added to root `AGENTS.md`'s `## Standards` list — `sync-api` is a sync command (already called out in onboarding rule 1.1 and the `SKILL.md` Operations table), not a standalone standard, so it isn't duplicated there.
- The super repo's root `AGENTS.md` `## Standards` list: item 1 ("Module standards") → **Makefile**, pointing to `standards/makefile.md`.
- `SKILL.md`'s reference table and frontmatter description updated to drop `module-standards-to-follow.md` and list `standards/makefile.md` instead.
- `how-to-organize-module.md` and `README.md`, which pointed at `module-standards-to-follow.md` for onboarding, now point at the Standards section in the super repo root `AGENTS.md`.

## Why

`module-standards-to-follow.md` had become a thin wrapper: two of its four sections were already one-line pointers to other files ([0004](0004-standards-directory.md) moved the AGENTS.md section out). Keeping it around as an extra hop added a layer between root `AGENTS.md`'s `## Standards` list and the actual content. The Makefile standard now has its own focused file in `standards/`; the API reference requirement is already enforced operationally via the `sync-api` command, so it doesn't need its own Standards entry.

## How it's maintained

- This amends [0004](0004-standards-directory.md)'s "How it's maintained" note that `module-standards-to-follow.md` stays as the top-level checklist — it's now retired.
- New cross-cutting *standards* (things every module must have, checked independently of a sync command) go in `.agents/skills/super/standards/`, with a numbered entry added to root `AGENTS.md`'s `## Standards` list and a row in `SKILL.md`'s reference table. Requirements already covered by a `super` skill operation (like `sync-api`) don't get a separate entry.
