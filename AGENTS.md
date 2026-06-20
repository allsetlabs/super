# Super Repo

Generic super repo: every project is a **git submodule** living under the top-level `modules/` directory, grouped into category subdirectories (e.g. `modules/forge-modules/` for projects built on the `forge` component library). No code lives in this repo itself.

## Skills

`AGENTS.md` is canonical; `CLAUDE.md` is a symlink to it — never edit the symlink.

## Standards

**Important:** every module and subdirectory must follow these standards to be considered part of the super repo.

1. **Makefile** — `super` skill, `standards/makefile.md`. Read when onboarding a new module, or auditing an existing one.
2. **AGENTS.md that teaches judgment** — `super` skill, `standards/agents-md.md`. Read before creating or updating any `AGENTS.md`/`CLAUDE.md`, in this repo or any module. Read when onboarding a new module, or auditing an existing one.
3. **Hook sync** — whenever you add, modify, or remove a hook in `.claude/hooks/` or `.claude/settings.json`, add its equivalent to `.kimi-code/hooks/` (and vice versa), adapting to each platform's syntax. The two hook directories must always mirror each other in intent.

## Before You Start

If the user hasn't already said which project they're working on, ask. Navigate to that module directory before making any changes.

If that module has a same-named agent under `.claude/agents/` (e.g. `memory/` → `memory` agent), delegate the work to that agent via the Agent tool instead of handling it directly. Pick the agent by module, not by task type — a module's agent handles all work in that module, regardless of what kind of task it is.

- **Claude**: invoke the agent at `.claude/agents/<name>.md` via the Agent tool.
- **Kimi**: spawn a `coder` sub-agent using the full prompt from `.claude/agents/<name>.md` (the same files serve both platforms — Kimi has no separate agents directory).

## Rules

0. **Autonomous agents — run without asking first:**
   - **On natural stop only** — if this session surfaced anything worth remembering *(personal: events, people, feelings, plans; work: what you built/changed, decisions, which module)*: invoke the `memory` agent (`.claude/agents/memory.md`) with `model: haiku` to append a timestamped entry to today's by_date file.
     - **Kimi**: spawn a `coder` sub-agent with the full prompt from `.claude/agents/memory.md`.
   - **On natural stop only** *(only when irreversible changes were made — new architecture, deleted data, major config, public API changes)*: invoke the `decision-records` agent (`.claude/agents/decision-records.md`) with `model: haiku` to write the ADR.
     - **Kimi**: spawn a `coder` sub-agent with the full prompt from `.claude/agents/decision-records.md`.
   - **On natural stop & after every git commit** *(always)*: invoke the `summarize-chat` agent (`.claude/agents/summarize-chat.md`) with `model: haiku` to write `.tmp/summarize-chat/$CLAUDE_CODE_SESSION_ID.json` with `progress` and `summary` fields (what was asked, done, current state, pending).
     - **Kimi**: spawn a `coder` sub-agent with the full prompt from `.claude/agents/summarize-chat.md`.

1. **Before commit** — always run in this order before any `git commit`:
   1. `sync-docs` (`super` skill) — update `docs/<module>/index.md` for any module whose code changed.
   2. `sync-api` (`super` skill) — run only if backend or API code was edited, to keep that module's `api.md` current.

2. **Adding a module** — when the user asks to clone, add, or submodule a repo: **NEVER clone or copy code into this repo — always `git submodule add`.** Categorize and place it per `super` skill, `standards/how-to-organize-module.md`.
   2.1 Once the module is added, onboard it per the Standards above, then run the `super` skill operations `sync-api` and `sync-docs` scoped to the newly added module directory.
3. **Before any git operation** (commit, push, branch, merge) — read and follow the `git-workflow` skill.
4. **Coding standards** — read the `coding-standards` skill before making any code change. All rules live there.
5. **Visual testing** — if the change has a visual component (web app, UI), open the page with Chrome MCP tools (`mcp__claude-in-chrome__*`), test it visually, and check the console. If anything looks odd, errors in the console, or doesn't work, fix and re-test — iterate until the goal is reached.
6. **Do not commit unless explicitly asked.** Never commit in the super repo itself. This top-level repo only tracks submodule pointers — it holds no real work, so its commits aren't yours to make. Only commit inside a relevant module submodule when the user explicitly asks you to commit, and only after following the `git-workflow` skill. Leave all super-repo-level changes (updated submodule pointers, `docs/`, `api.md`, ADRs) staged and uncommitted for the user to review and commit themselves.
