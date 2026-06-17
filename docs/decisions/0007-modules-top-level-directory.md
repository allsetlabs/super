# 0007 — All modules nested under a top-level `modules/` directory

**Date:** 2026-06-16

**Status:** Accepted

## Decision

- Every git submodule now lives under a single top-level `modules/` directory instead of at the repo root. Category directories are nested inside it:
  - `forge-modules/<module>` → `modules/forge-modules/<module>`
  - `artifacts` → `modules/artifacts`
  - `memory` → `modules/memory`
- `.gitmodules` paths were re-prefixed with `modules/`; the submodule **names** (and therefore the gitdirs under `.git/modules/`) were kept unchanged.
- The `memory` submodule's gitdir was renamed `journal → memory` so its name, gitdir, and `.git/config` section are consistent (it was a leftover from an earlier `journal → memory` repo rename).
- Layout standard ([how-to-organize-module.md](../../.agents/skills/super/standards/how-to-organize-module.md)) updated: new modules are added with `git submodule add <url> modules/<category>/<path>`.
- Docs mirror the module path, so `docs/<category>/` moved to `docs/modules/<category>/` ([ADR 0001](0001-docs-live-in-super-repo.md) layout rule, new depth).
- References to the old root paths were updated across build config (`package.json` workspaces, `eslint.config.js` tsconfig globs), module skills under `.agents/skills/`, and repo docs.

## Why

The repo root had grown a mix of submodules (`forge-modules/`, `artifacts/`, `memory/`) interleaved with repo-level files (configs, `docs/`, `.github/`). Collecting every module under one `modules/` directory gives a single, predictable home for project code and keeps the root scoped to super-repo machinery. It also makes "list all modules" a single directory walk and removes the ambiguity that let a stray duplicate (`modules/memory` vs a root `memory/` submodule) exist unnoticed.

## How it's maintained

- New modules are added under `modules/<category>/<path>` via `git submodule add`; `git submodule status` remains the single source of truth for the layout.
- `sync-docs` writes each module's docs to `docs/<module-directory-path>/index.md`, which now resolves under `docs/modules/`.
- Submodule names in `.gitmodules` are kept aligned with their gitdir under `.git/modules/`; when a submodule's repo is renamed, rename the gitdir to match rather than leaving a stale name.
