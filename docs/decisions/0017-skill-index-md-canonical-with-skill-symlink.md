# 0017 — `index.md` as canonical skill file, `SKILL.md` as symlink

**Date**: 2026-06-27
**Status**: Accepted

## Context

Skills under `.agents/skills/<name>/` were stored as `SKILL.md`. The Claude Code skill loader expects `SKILL.md`, but the filename `SKILL.md` is platform-specific to the Claude Code harness. A request came in to adopt a more generic, portable filename that other tooling (Kimi, Copilot, etc.) could reference without a platform assumption baked into the name.

## Decision

Rename the authoritative skill file to `index.md`. Make `SKILL.md` a symlink pointing to `index.md`, so the Claude Code skill loader continues to find it at the expected path.

This mirrors the existing `AGENTS.md` (canonical) / `CLAUDE.md` (symlink) pattern already established in this repo.

## Rationale

- `index.md` is a convention-neutral name — it reads as "the entry point for this directory" regardless of platform.
- The symlink approach means zero breakage to any tooling that depends on `SKILL.md` while making `index.md` the authoritative source.
- Consistency with the `AGENTS.md`/`CLAUDE.md` symlink pattern keeps the repo's conventions uniform.

## Consequences

- All future skills should be authored in `index.md`; `SKILL.md` is a redirect, not edited directly.
- Existing skills that still have only `SKILL.md` (no `index.md`) are grandfathered until they're next updated.
- Any tooling that follows symlinks (git, editors) sees `index.md`; tooling that resolves to the path literally sees `SKILL.md` — both work correctly.
