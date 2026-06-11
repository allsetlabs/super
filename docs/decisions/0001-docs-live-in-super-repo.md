# 0001 — Module docs and API references live in the super repo, not in modules

**Date:** 2026-06-10
**Status:** Accepted

## Decision

- Module documentation lives in the super repo at `docs/<module-directory-path>/` (e.g. `docs/forge-modules/devbot/`), not in `docs/` folders inside module repos.
- API references live in each module's skill at `.agents/skills/<module>/api.md`, not in the module repo.
- In-module `docs/` folders are deleted; the only docs a module keeps are its `AGENTS.md` (with `CLAUDE.md` symlink) and `README.md`.

## Why

**The super repo must have all the context even when the modules are not cloned.** Submodules are cloned lazily — an AI session (or a fresh checkout) working from the super repo often has only the super repo itself. If docs live inside module repos, that context is invisible until the module is cloned. Keeping docs and API references in the super repo means:

1. Any session can understand every module (purpose, architecture, how to run, API surface) without initializing a single submodule.
2. Docs are versioned with the super repo's view of the world and synced from real code by the `super` skill (`sync-docs`, `sync-api`), so they don't drift silently inside ten different repos.
3. Skills auto-trigger with the API reference attached, so agents calling a module's backend never need the module checked out.

## How it's maintained

- `sync-docs` (super skill) regenerates `docs/<module>/index.md` from module code + commit history, tracked by `last_synced_commit` frontmatter.
- `sync-api` (super skill) regenerates `.agents/skills/<module>/api.md` from route files.
- The stale in-module docs (forge, portfolio, seekr, devbot/reusables) were read, their useful content absorbed into the new docs, and deleted from the module repos on 2026-06-10.
