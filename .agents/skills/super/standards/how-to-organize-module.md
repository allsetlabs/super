# how-to-organize-module — How to Organize and Add Modules

The super repo holds no code of its own. Every project is a **git submodule**. This file is the procedure for adding a new module or reorganizing existing ones.

## The One Hard Rule

**NEVER clone or copy code into this repo. Always `git submodule add`.** If a repo is already cloned somewhere locally, still add it here as a submodule from its remote URL — never `cp`/`git clone` into the tree.

## Layout Principles

1. **All submodules live under `modules/`.** The `modules/` directory is the root container for all submodules. Category subdirectories group related projects within it — e.g. `modules/forge-modules/` holds projects built on the `forge` component library. Standalone modules go directly under `modules/`.
2. **Subdirectories group related projects within a category** (e.g. several sites for the same organization live under `modules/<category>/<org>/<project>`). Flat entries under `modules/` are for standalone projects only.
3. **Discover, don't memorize.** The current layout is always `git submodule status` — there is no hardcoded module map.

## Adding a New Module

1. **Inspect the repo first** — read its `package.json` / `pyproject.toml`, imports, and README to understand what it is and what it depends on. Never place it without looking.
2. **Categorize:**
   - Uses the `forge` component library → `modules/forge-modules/`
   - Fits an existing group (check `git submodule status` and top-level dirs) → that group
   - Several related projects exist or are expected → group them in a subdirectory
   - Fits nothing → propose a new category directory under `modules/` to the user before creating it
3. **Add it:**
   ```bash
   git submodule add <remote-url> modules/<category>/<path>
   ```
4. **Onboard it** — apply the Standards from the super repo root `AGENTS.md` (Makefile, AGENTS.md/CLAUDE.md symlink, decision records, API reference if it has a backend), run the `/fix-coding-standards` command scoped to the new module, then run the sync operations scoped to it: [sync-api.md](sync-api.md), [sync-docs.md](sync-docs.md).
5. **Commit via branch + PR** per the `git-workflow` skill — never directly to main.

## Reorganizing / Moving a Module

Use `git mv` on the submodule path (it updates `.gitmodules`), verify with `git submodule status`, and update any references to the old path (docs, Makefiles, skills).
