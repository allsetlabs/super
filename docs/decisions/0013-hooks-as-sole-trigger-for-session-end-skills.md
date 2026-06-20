# 0013 — Hooks as sole trigger for session-end skills

**Date**: 2026-06-20
**Status**: Accepted

## Context

After converting the session-end tasks to skills (ADR 0012), Rule 0 in `AGENTS.md` documented the same triggering logic: invoke memory, decision-records, and summarize-chat at session end. The stop hook in `.claude/hooks/stop-hook.sh` already carries the complete, authoritative instructions for when and how to invoke these skills.

## Decision

Remove Rule 0 from `AGENTS.md` entirely. The stop hook in `.claude/hooks/stop-hook.sh` is the sole trigger and source of truth for session-end skill invocations. `AGENTS.md` documents no session-end automation.

## Rationale

- The hooks fire at precisely the right moment with the full instruction — Claude doesn't need to pre-load this from `AGENTS.md`
- Documenting the same behavior in two places creates drift risk: a skill rename or behavior change requires updating both the hook and `AGENTS.md`
- Session-end tasks are reactive (triggered by the harness), not proactive rules for Claude to remember — they don't belong in the Rules section alongside commit and coding standards
- The trivial-session threshold (< 20 KB) in the hook already handles the case where `AGENTS.md` previously acted as a fallback

## Consequences

- `AGENTS.md` is shorter and focused on rules Claude must actively follow during a session
- Any contributor wanting to understand session-end automation must read the hook scripts and skill files directly
- Adding a new session-end skill means updating only the hook, not `AGENTS.md`
