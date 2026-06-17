# 0007 — All submodules live under `modules/`

**Date:** 2026-06-16
**Status:** Accepted

## Decision

All git submodules live under a single `modules/` top-level directory. Category subdirectories go inside it (e.g. `modules/forge-modules/`, standalone modules directly as `modules/memory/`). No submodules exist at the repo root.

## Why

The root was becoming a flat mix of category directories (`forge-modules/`) and standalone submodules (`memory/`, `artifacts/`) alongside repo-level files (`AGENTS.md`, `Makefile`, `docs/`, etc.). This made it hard to distinguish "super-repo infrastructure" from "module containers" at a glance.

A single `modules/` directory makes the split explicit: everything inside is a submodule or a category of submodules; everything outside is super-repo infrastructure.

## What changed

- `forge-modules/` → `modules/forge-modules/`
- `memory/` → `modules/memory/`
- `artifacts/` → `modules/artifacts/`
- `docs/forge-modules/` → `docs/modules/forge-modules/`
- `docs/memory/` → `docs/modules/memory/`
- All path references updated in `AGENTS.md`, `Makefile`, `package.json`, `eslint.config.js`, `README.md`, `docs/index.md`, and all `.agents/skills/` files.

## Convention going forward

New submodules: `git submodule add <url> modules/<category>/<name>` (or `modules/<name>` for standalones).
