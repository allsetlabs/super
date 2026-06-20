# Super Repo

Generic super repo: every project is a **git submodule** living under the top-level `modules/` directory, grouped into category subdirectories (e.g. `modules/forge-modules/` for projects built on the `forge` component library). No code lives in this repo itself.

## Skills

`AGENTS.md` is canonical; `CLAUDE.md` is a symlink to it — never edit the symlink.

## Standards

**Important:** every module and subdirectory must follow these standards to be considered part of the super repo.

1. **Makefile** — `super` skill, `standards/makefile.md`. Read when onboarding a new module, or auditing an existing one.
2. **AGENTS.md that teaches judgment** — `super` skill, `standards/agents-md.md`. Read before creating or updating any `AGENTS.md`/`CLAUDE.md`, in this repo or any module. Read when onboarding a new module, or auditing an existing one.

## Before You Start

If the user hasn't already said which project they're working on, ask. Navigate to that module directory before making any changes.

If that module has a same-named agent under `.kimi-code/agents/` (for Kimi) or `.claude/agents/` (for Claude) (e.g. `memory/` → `memory` agent), delegate the work to that agent via the Agent tool instead of handling it directly. Pick the agent by module, not by task type — a module's agent handles all work in that module, regardless of what kind of task it is.

## Rules

0. **Memory capture** — at natural stopping points or session end, invoke the `memory` agent to draft a journal entry for anything worth remembering from the session (personal or work). Do it autonomously — don't ask first.
   - **Kimi**: dispatch a `coder` sub-agent via the Agent tool, passing the full prompt from `.kimi-code/agents/memory.md`.
   - **Claude**: invoke the `memory` agent via the Agent tool using `.claude/agents/memory.md`.
1. **Adding a module** — when the user asks to clone, add, or submodule a repo: **NEVER clone or copy code into this repo — always `git submodule add`.** Categorize and place it per `super` skill, `standards/how-to-organize-module.md`.
   1.1 Once the module is added, onboard it per the Standards above, then run the `super` skill operations `sync-api` and `sync-docs` scoped to the newly added module directory.
2. **Before any git operation** (commit, push, branch, merge) — read and follow the `git-workflow` skill.
3. **Coding standards** — read the `coding-standards` skill before making any code change. All rules live there.
4. **On every code change**, run these steps before committing:
   1. `npm run lint` — linting is centralized at the super repo root; many modules do not have a local lint command.
   2. `sync-docs` (`super` skill) — update `docs/<module>/index.md` for any module whose code changed.
   3. `sync-api` (`super` skill) — run only if backend or API code was edited, to keep that module's `api.md` current.
   4. `standards/decision-records.md` (`super` skill) — if this session made a non-obvious, hard-to-reverse decision (architecture, library choice, directory layout, API pattern, cross-module convention), record it as an ADR before or in the same commit as the change.
5. **Visual testing** — if the change has a visual component (web app, UI), open the page with Chrome MCP tools (`mcp__claude-in-chrome__*`), test it visually, and check the console. If anything looks odd, errors in the console, or doesn't work, fix and re-test — iterate until the goal is reached.
6. **Do not commit unless explicitly asked.** Never commit in the super repo itself. This top-level repo only tracks submodule pointers — it holds no real work, so its commits aren't yours to make. Only commit inside a relevant module submodule when the user explicitly asks you to commit, and only after following the `git-workflow` skill. Leave all super-repo-level changes (updated submodule pointers, `docs/`, `api.md`, ADRs) staged and uncommitted for the user to review and commit themselves.
