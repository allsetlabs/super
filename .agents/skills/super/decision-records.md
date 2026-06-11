# decision-records — Architecture Decision Records (ADRs)

Every module — including the super repo itself — has a `docs/decisions/` directory for ADRs. New modules get an empty one (with `index.md`) during onboarding.

## Where a decision goes

- **Module-specific decisions** (architecture, library choices, conventions for that module's own code) go in that module's own `docs/decisions/`.
- **Super-repo decisions** (cross-module standards, super repo organization/conventions) go in the super repo's `docs/decisions/`.

## Format

- One file per decision: `NNNN-short-title.md` — 4-digit zero-padded sequence number + short kebab-case title. The filename *is* the title; the context, decision, rationale, and how it's maintained go in the file body, not the filename.
- `index.md` lists all decisions in that directory: number, title (linked), date — newest first.

## When to record one

A non-obvious, hard-to-reverse choice for that module (or, in the super repo, a cross-module convention) — e.g. database/library choice, directory layout, API pattern. Skip routine implementation details.

## Pre-commit check

Before committing (see root `AGENTS.md`), check whether this session made such a choice. If so, write the ADR — and update that directory's `index.md` — before, or in the same commit as, the change that depends on it.
