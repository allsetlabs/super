---
name: decision-records
description: Architecture Decision Record scribe. At session end, checks whether any non-obvious or hard-to-reverse decisions were made and writes an ADR in the appropriate module's docs/decisions/ directory. Runs autonomously — no approval needed before writing.
---

# Decision Records Skill

**Role**: ADR scribe for all modules in the super repo.
**Scope**: At session end, determine whether any non-obvious, hard-to-reverse decisions were made; if so, write the Architecture Decision Record in the right place.

## Where ADRs Live

Every module — including the super repo itself — has a `docs/decisions/` directory. New modules get an empty one (with `index.md`) during onboarding.

- **Module-specific decisions** (architecture, library choices, conventions for that module's own code) → that module's `docs/decisions/`
- **Cross-module or super-repo decisions** (standards, repo organization, cross-module conventions) → the super repo's `docs/decisions/`

## When to Write an ADR

Record a decision when this session made a choice that is:

- **Non-obvious** — not derivable from the code alone (a reasonable engineer would wonder "why did they do it this way?")
- **Hard to reverse** — changing it later would require significant effort or migration

Examples: library choice, database schema design, directory layout, cross-module convention, API contract, authentication pattern.

Skip routine implementation details — if it's obvious from the code, skip it.

## How to Write

1. Identify all candidate decisions from the session. If there are none, stop silently.
2. For each decision, determine the right location (see above).
3. Find the next sequence number: list existing `NNNN-*.md` files in that `docs/decisions/` directory and increment.
4. Write `NNNN-short-title.md` — one file per decision, 4-digit zero-padded sequence + short kebab-case title. The filename is the title; all context goes in the body:

   ```
   # NNNN — Short Title

   **Date**: YYYY-MM-DD
   **Status**: Accepted

   ## Context
   <what problem or situation prompted this decision>

   ## Decision
   <what was decided>

   ## Rationale
   <why this choice over the alternatives>

   ## Consequences
   <trade-offs, future implications, or maintenance notes>
   ```

5. Update `index.md` in the same directory — prepend a row (newest first): `| NNNN | [Short Title](NNNN-short-title.md) | YYYY-MM-DD |`
6. **Do not commit.** Leave the files staged for the user to include in their next commit.

## Hard Rules

- Write autonomously — never ask for approval before writing an ADR.
- If nothing qualifies, stop silently — do not output a message saying "no decisions found."
- Never invent decisions that weren't actually made in this session.
- Do not commit; the user commits ADRs with the related code change.
