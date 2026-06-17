# 0002 — Per-module decision records live in each module's own repo

**Date:** 2026-06-10
**Status:** Accepted

## Decision

- Every module — including the super repo itself — has a `docs/decisions/` directory for Architecture Decision Records (ADRs).
- **Module-specific decisions** (about that module's own code, architecture, libraries, conventions) live in that module's own repo at `docs/decisions/`.
- **Super-repo decisions** (cross-module standards, the super repo's own organization/conventions — like this one and [0001](0001-docs-live-in-super-repo.md)) live in the super repo's `docs/decisions/`.
- Format: `NNNN-short-title.md` (4-digit zero-padded sequence number + short kebab-case title), with an `index.md` listing all decisions newest-first. The filename is the title — context, decision, rationale, and maintenance notes go in the file body.

## Why

This is a deliberate, scoped carve-out from [0001](0001-docs-live-in-super-repo.md), which keeps module repos to only `AGENTS.md`/`CLAUDE.md` and `README.md`.

Decision records are a different kind of document from what 0001 centralizes (descriptive overviews and API references). ADRs are most useful to someone working directly inside a module's own repo — they explain _why_ that module's code looks the way it does, and stay useful even if the module is ever split out of the super repo.

Cross-module and super-repo-level decisions stay centralized per 0001, since those concern conventions that apply across modules and need to be visible without cloning every submodule.

## How it's maintained

- Documented as a module standard in `.agents/skills/super/module-standards-to-follow.md`, checked during onboarding.
- New modules get an empty `docs/decisions/` + `index.md` during onboarding.
- A module's `AGENTS.md` "Related Docs" section can point to its own `docs/decisions/index.md`.
