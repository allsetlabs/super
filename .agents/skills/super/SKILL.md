---
name: super
description: Super-repo maintenance skill — organize/onboard git submodules, enforce module standards, and keep the super repo in sync with all modules. Operations, sync-docs (per-module docs under docs/), sync-api (AI-readable API reference for every module with a backend). Reference, how-to-organize-module (adding/categorizing submodules), standards/ (what every module must have — Makefile, AGENTS.md, decision records, API reference). Use when the user says "sync docs", "sync api", "add a module/submodule", "/super", or when running scheduled super-repo syncs.
model: opus
---

# Super Repo Maintenance Skill

Keeps the super repo and its modules organized and in sync.

**Invoked with no operation?** Ask the user which one to run (AskUserQuestion) with options: `sync-api`, `sync-docs`, `all`. Do not guess. Only when running unattended (scheduled, no user to ask) does a bare invocation mean `all`. `all` runs **sync-api → sync-docs** (docs last so they describe the current code).

## Operations

| Operation | Procedure file | What it does |
|-----------|---------------|--------------|
| `sync-docs` | [sync-docs.md](sync-docs.md) | Create/update per-module documentation in `docs/<module-directory-path>/index.md` from module code + commit history. Incremental via last-synced commit SHA. |
| `sync-api` | [sync-api.md](sync-api.md) | Ensure every module with a backend has an up-to-date AI-readable API reference doc, generated from route files. |

Read the procedure file for the operation before executing it.

Every operation accepts an optional **module scope** (e.g. `sync-docs <module-directory-path>`): when given, process only that module instead of all of them — used when onboarding a newly added module.

## Reference

| Topic | File | When to load |
|-------|------|--------------|
| Organize / add modules | [standards/how-to-organize-module.md](standards/how-to-organize-module.md) | Adding a submodule, cloning a repo into the super repo, categorizing or moving modules |
| Makefile standard | [standards/makefile.md](standards/makefile.md) | Onboarding a new module or auditing an existing one |
| AGENTS.md that teaches judgment | [standards/agents-md.md](standards/agents-md.md) | Creating or updating any `AGENTS.md`/`CLAUDE.md`, in this repo or any module |
| Decision records | [standards/decision-records.md](standards/decision-records.md) | Recording an ADR, or the pre-commit check for whether one is needed |

## Shared Rules (apply to every operation)

1. **Discover modules, never hardcode** — the module list is `git submodule status` from the super repo root. Untracked directories are not modules; skip them.
2. **Git safety** — follow the `git-workflow` skill. Changes inside module repos and the super repo go on branches with PRs, never direct to main. Mandatory when run unattended (scheduled).
3. **Minimal changes** — only update what actually differs from reality.
4. **Submodule pointers** — if an operation commits inside a module repo, the super-repo PR must include the corresponding submodule pointer bump.
5. **Report** — every operation ends with its report block so scheduled runs leave a readable trail.
