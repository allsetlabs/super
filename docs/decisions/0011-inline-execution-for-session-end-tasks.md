# 0011 — Inline Execution for Session-End Tasks

**Date**: 2026-06-20
**Status**: Accepted

## Context

The stop hook (`.claude/hooks/stop-hook.sh`) and `AGENTS.md` Rule 0 instructed Claude to invoke `memory`, `decision-records`, and `summarize-chat` at session end. Two mechanisms were tried:

1. **Agent tool** — spawns a fresh sub-agent with no conversation context. The sub-agent had to re-derive everything from git history, leading to inaccurate summaries and missed context.
2. **Skill tool** — attempted as a fix, but discovered these tasks are not Skill-tool-callable; they are user-only slash commands. Calling them via the Skill tool returns errors (`Unknown skill` or `UI command, not a skill`).

## Decision

Session-end tasks (memory, decision-records, summarize-chat) are executed **directly inline** in the current conversation. The stop hook and `AGENTS.md` now instruct Claude to read the relevant `.md` instruction file and act on it in the same context window — no Agent or Skill tool invocation.

Kimi is unaffected: it has no inline execution mechanism, so its hooks still spawn coder sub-agents as before.

## Rationale

Inline execution is the only approach that gives these tasks full conversation context without the cold-start problem. The tasks don't need isolation or a separate model — they need to know what happened in the session, which is only available in the current window.

## Consequences

- Session-end tasks are faster (no sub-agent spawn overhead) and more accurate (full context).
- The `.md` files in `.claude/agents/` continue to serve as instruction references — they are now read directly rather than used as agent definitions for Claude.
- Kimi's sub-agent approach diverges from Claude's inline approach; both hook files must be kept in sync in intent while diverging in mechanism (per the hook-sync standard).
