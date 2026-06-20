# 0008 — Rename session-end hooks to `stop-hook`

**Date**: 2026-06-20
**Status**: Accepted

## Context

The super repo uses a Claude `Stop` hook (`.claude/hooks/memory-reminder.sh`) and a mirrored Kimi `Stop` hook (`.kimi-code/hooks/memory-stop-hook.sh`) to prompt the agent to run session-end agents before ending a substantive session. Over time, the hook's responsibilities grew beyond the memory agent to also include the decision-records agent and the summarize-chat agent. The original names therefore became misleading: a maintainer seeing `memory-reminder.sh` or `memory-stop-hook.sh` would reasonably assume the hook only handles memory capture.

## Decision

Rename the session-end hooks to a single, responsibility-agnostic name:

- `.claude/hooks/memory-reminder.sh` → `.claude/hooks/stop-hook.sh`
- `.kimi-code/hooks/memory-stop-hook.sh` → `.kimi-code/hooks/stop-hook.sh`

Update all references accordingly:

- `.claude/settings.json` now calls `.claude/hooks/stop-hook.sh` for the `Stop` event.
- `.kimi-code/config/hooks.toml` now calls `.kimi-code/hooks/stop-hook.sh` for the `Stop` event.
- The per-session marker files inside both scripts now use `claude-stop-hook-${session_id}` and `kimi-stop-hook-${session_id}` respectively.

## Rationale

The new name reflects what the hook actually does: it intercepts the stop event and orchestrates all session-end agents, not just memory. Keeping the names aligned across Claude and Kimi also makes the cross-platform mirroring rule easier to follow and audit. A generic name avoids another rename if additional session-end agents are added later. The chat-summary agent was renamed to summarize-chat in the same session; see ADR 0009 for the rationale.

## Consequences

- Both Claude and Kimi hook configurations must reference the same logical hook name; future renames require touching both sides.
- The per-session marker paths changed, so old marker files under the previous names will be ignored; this is harmless because markers are only used to avoid nagging twice in the same session.
- The AGENTS.md mirroring rule remains in effect: any future change to one hook must be ported to the other.
