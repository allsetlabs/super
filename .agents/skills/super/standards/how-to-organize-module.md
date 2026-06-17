# how-to-organize-module — How to Organize and Add Modules

The super repo holds no code of its own. Every project is a **git submodule**. This file is the procedure for adding a new module or reorganizing existing ones.

## The One Hard Rule

**NEVER clone or copy code into this repo. Always `git submodule add`.** If a repo is already cloned somewhere locally, still add it here as a submodule from its remote URL — never `cp`/`git clone` into the tree.

## Layout Principles

1. **All modules live under `modules/`, grouped by category.** Every submodule sits under the top-level `modules/` directory in a category subdirectory that groups projects sharing something structural — e.g. `modules/forge-modules/` holds projects built on the `forge` component library. The super repo itself is generic: do not assume every project belongs in an existing group.
2. **Subdirectories group related projects within a category** (e.g. several sites for the same organization live under `modules/<category>/<org>/<project>`). Flat entries are for standalone projects only.
3. **Discover, don't memorize.** The current layout is always `git submodule status` — there is no hardcoded module map.

## Adding a New Module

1. **Inspect the repo first** — read its `package.json` / `pyproject.toml`, imports, and README to understand what it is and what it depends on. Never place it without looking.
2. **Categorize:**
   - Uses the `forge` component library → `modules/forge-modules/`
   - Fits an existing group (check `git submodule status` and the dirs under `modules/`) → that group
   - Several related projects exist or are expected → group them in a subdirectory
   - Fits nothing → propose a new category directory under `modules/` to the user before creating it
3. **Add it:**
   ```bash
   git submodule add <remote-url> modules/<category>/<path>
   ```
4. **Register it for linting** — linting is centralized at the super repo root. If the module has TypeScript, add its `tsconfig.json` path(s) to `parserOptions.project` in the root `eslint.config.js` so `npm run lint` type-checks it. Modules under `modules/forge-modules/` are already covered by the existing globs; a new category needs its own glob (e.g. `./modules/<category>/*/tsconfig.json` and `./modules/<category>/**/*/tsconfig.json`).
5. **Onboard it** — apply the Standards from the super repo root `AGENTS.md` (Makefile, AGENTS.md/CLAUDE.md symlink, decision records, API reference if it has a backend), then run the sync operations scoped to it: [sync-api.md](sync-api.md), [sync-docs.md](sync-docs.md).
6. **Commit** per the `git-workflow` skill.

## Reorganizing / Moving a Module

Use `git mv` on the submodule path (it updates `.gitmodules`), verify with `git submodule status`, and update any references to the old path (docs, Makefiles, skills).
