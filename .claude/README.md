# Claude Code Adapter

This directory is the **Claude Code adapter** for the super repo. Canonical instructions live in the root `AGENTS.md` (`CLAUDE.md` is a symlink), and all skills live in `.agents/skills/` so Codex, Copilot CLI, and Kimi CLI can use them too.

> Don't enumerate modules, skills, or agents in this file — the directories below are the source of truth, and lists here go stale.

## Structure

```
.claude/
├── agents/        # Claude Code subagents (mirrored to .github/agents/ for Copilot — edit here first)
├── commands/      # Claude-only slash commands
├── skills/ → ../.agents/skills/   # Symlink — skills live in .agents/skills (cross-tool)
├── hooks/         # PreToolUse hooks (e.g. main-branch protection)
├── settings.json  # Shared Claude Code settings
└── tasks/         # Task execution workspace
```

## Skills (`.agents/skills/`)

One directory per skill; `SKILL.md` is the entry point and its frontmatter `description` is what triggers auto-discovery. Three kinds:

- **Module skills** — one per submodule, named after the module. All module-specific knowledge (patterns, APIs, workflows) belongs in the module's own skill, never in generic docs.
- **Generic skills** — apply to every module (e.g. `coding-standards`, `git-workflow`, `super`, `dedup`, `architect`).
- **Downloaded skills** — third-party (tracked in `skills-lock.json`, do not edit).

To list them: `ls .agents/skills/`. Each `SKILL.md` describes itself.

## Slash Commands (`.claude/commands/`)

Claude-mechanics-dependent, user-invoked workflows. Everything reusable across AI CLIs belongs in `.agents/skills/` instead (skills are still invokable as `/name` in Claude). To list them: `ls .claude/commands/`.

## Agents (`.claude/agents/`)

Subagents for delegated work, invoked via the Agent tool (`subagent_type="<name>"`). Module-specific agents are allowed here — each agent's own file documents its scope. Copilot mirrors live in `.github/agents/`; update the mirror when editing an agent.

## Conventions

- **Before creating components**: check the shared component library first
- **After code changes**: run `npm run lint` and `npm run type-check`
- **Custom colors only**: never use default Tailwind colors when the project defines a palette
