# Super Repo

Generic super repo: every project is a **git submodule** organized under category directories (e.g. `forge-modules/` for projects built on the `forge` component library). No code lives in this repo itself.

## Skills

`AGENTS.md` is canonical; `CLAUDE.md` is a symlink to it — never edit the symlink.

## Before You Start

If the user hasn't already said which project they're working on, ask. Navigate to that module directory before making any changes.

## Rules

1. **Adding a module** — when the user asks to clone, add, or submodule a repo: **NEVER clone or copy code into this repo — always `git submodule add`.** Read `.agents/skills/super/how-to-organize-module.md` first to categorize and place it.
   1. Once the module is added, onboard it: apply `.agents/skills/super/module-standards-to-follow.md`, run `/fix-coding-standards` scoped to that module, then run the `super` skill operations `sync-api` and `sync-docs` scoped to it.
2. **Before any git operation** (commit, push, branch, merge) — read and follow the `git-workflow` skill at `.agents/skills/git-workflow/SKILL.md`.
3. **NEVER commit or push directly to `main`** — always work on a branch and open a PR.
4. **Coding standards** — all rules live in `.agents/skills/coding-standards/`. Run `/fix-coding-standards` to auto-fix.
5. **On every code change** — run `npm run lint && npm run type-check` before considering the change done.
6. **Visual testing** — if the change has a visual component (web app, UI), open the page with Chrome MCP tools (`mcp__claude-in-chrome__*`), test it visually, and check the console. If anything looks odd, errors in the console, or doesn't work, fix and re-test — iterate until the goal is reached.
