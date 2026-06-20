# 0012 — Session-end tasks as skills, not agents

**Date**: 2026-06-20
**Status**: Accepted

## Context

The three session-end automation tasks (memory, decision-records, summarize-chat) were defined as agent files under `.claude/agents/`. An earlier decision (0011) established that they must execute inline — reading the `.md` files and acting in the current conversation window — rather than being spawned as sub-agents, because spawned agents start cold with no session context.

The agent file format is semantically dual-use: it implies the file can either be spawned (isolated context, parent must pass context explicitly) or read inline. Placing always-inline tasks under `.claude/agents/` was misleading and required a comment in every hook to clarify the restriction.

## Decision

Convert all three session-end tasks from agent files (`.claude/agents/*.md`) to skills (`.claude/skills/*/SKILL.md`). Update the stop hook, PostToolUse hook, `AGENTS.md` Rule 0, and all Kimi hooks to reference the skill files. Delete the agent files.

## Rationale

Skills are the correct abstraction for always-inline execution. The Skill tool loads the skill's instructions into the current conversation context — precisely the inline behavior required. Using skills:

- Eliminates the misleading dual-use implication of agent files
- Removes the need for "do not spawn as sub-agent" comments in every hook
- Makes all three tasks discoverable in the skills list and invocable via `/skill-name`
- Signals clearly to any contributor that these tasks share the caller's full conversation context

Kimi has no Skill tool equivalent and continues to spawn coder sub-agents, but now reads instructions from `.claude/skills/X/SKILL.md` instead of the deleted agent files — same content, correct paths.

## Consequences

- The three `.claude/agents/` files are gone; contributors must look in `.claude/skills/` for session-end task instructions.
- Adding a new session-end task means creating a skill, not an agent file.
- Kimi hooks must be kept in sync with skill file paths whenever a skill is renamed or moved.
