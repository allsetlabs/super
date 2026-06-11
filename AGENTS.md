# Super Repo

Generic super repo: every project is a **git submodule** organized under category directories (e.g. `forge-modules/` for projects built on the `forge` component library). No code lives in this repo itself.

## Skills

`AGENTS.md` is canonical; `CLAUDE.md` is a symlink to it — never edit the symlink.

## Standards

**Important:** every module and subdirectory must follow these standards to be considered part of the super repo.

1. **Module organization** — `super` skill, `standards/how-to-organize-module.md`. Read when adding, categorizing, or moving a module.
2. **Makefile** — `super` skill, `standards/makefile.md`. Read when onboarding a new module, or auditing an existing one.
3. **AGENTS.md that teaches judgment** — `super` skill, `standards/agents-md.md`. Read before creating or updating any `AGENTS.md`/`CLAUDE.md`, in this repo or any module. Read when onboarding a new module, or auditing an existing one.
4. **Decision records** — `super` skill, `standards/decision-records.md`. Read when recording an ADR, or for the pre-commit check on whether one is needed.

## Before You Start

If the user hasn't already said which project they're working on, ask. Navigate to that module directory before making any changes.

## Rules

1. **Adding a module** — when the user asks to clone, add, or submodule a repo: **NEVER clone or copy code into this repo — always `git submodule add`.** Categorize and place it per the Standards above.
   1.1 Once the module is added, onboard it per the Standards above, then run the `super` skill operations `sync-api` and `sync-docs` scoped to the newly added module directory.
2. **Before any git operation** (commit, push, branch, merge) — read and follow the `git-workflow` skill.
3. **NEVER commit or push directly to `main`** — always work on a branch and open a PR.
4. **Coding standards** — all rules live in the `coding-standards` skill. Run `/fix-coding-standards` to auto-fix.
5. **On every code change** — run the relevant module's available validation commands before considering the change done. Linting is centralized at the super repo root (`npm run lint`); many modules intentionally do not have a local `npm run lint`.
   5.1 **Before committing** — determine whether docs need to sync: if the module's code changed, run the `super` skill's `sync-docs` operation (scoped to that module) to update `docs/<module>/index.md`. If backend/API code was edited, also run `sync-api` to keep that module's skill `api.md` current.
   5.2 **Before committing** — if this session made a non-obvious, hard-to-reverse decision (architecture, library choice, directory layout, API pattern, cross-module convention), record it as an ADR per the Decision records standard above, before, or in the same commit as, the change that depends on it.
6. **Visual testing** — if the change has a visual component (web app, UI), open the page with Chrome MCP tools (`mcp__claude-in-chrome__*`), test it visually, and check the console. If anything looks odd, errors in the console, or doesn't work, fix and re-test — iterate until the goal is reached.
